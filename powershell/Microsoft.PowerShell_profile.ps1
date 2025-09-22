<# =======================================================================
 PowerShell Profile (Dallas)
 ------------------------------------------------------------------------
 • Initializes Starship (if present) using your config path
 • Shows a system summary with fastfetch (if present)
 • Adds an iperf helper function that forwards arguments
 • Safely imports useful modules (with version pin for PSReadLine)
 • Sets a Terminal-Icons theme (if available)
 • Tunes PSReadLine behavior (if available)
 • Provides Linux-like `id` and `groups` commands on Windows
 ------------------------------------------------------------------------
 Notes:
 - Everything is defensive: if a tool/module isn't installed, the profile
   won't error—it will just log a helpful message.
 - Feel free to tweak colors, messages, or modules you want to auto-load.
 ======================================================================= #>

# -----------------------------
# Helper: Pretty status output
# -----------------------------
function Write-Status {
    param(
        [Parameter(Mandatory)]
        [ValidateSet('OK','WARN','ERR','INFO')]
        [string]$Level,
        [Parameter(Mandatory)]
        [string]$Message
    )

    $prefix, $color = switch ($Level) {
        'OK'   { '✔', 'Green' }
        'WARN' { '▲', 'Yellow' }
        'ERR'  { '✖', 'Red' }
        'INFO' { 'ℹ', 'Cyan' }
    }

    try {
        Write-Host "[$prefix] $Message" -ForegroundColor $color
    } catch {
        # In rare TTY cases (no colors), just write plain text
        Write-Host "[$prefix] $Message"
    }
}

# -----------------------------
# Fast system summary (fastfetch)
# -----------------------------
# Will run fastfetch if present; harmlessly skip if not.
$fastfetchCmd = Get-Command fastfetch -ErrorAction SilentlyContinue
if ($fastfetchCmd) {
    try {
        fastfetch
        # No status line here to keep output minimal if command succeeds
    } catch {
        Write-Status WARN "fastfetch failed: $($_.Exception.Message)"
    }
} else {
    Write-Status INFO "fastfetch not installed—skipping quick system summary."
}

# -----------------------------
# Environment & Prompt (Starship)
# -----------------------------
# Configure Starship path and initialize if available
$env:STARSHIP_CONFIG = Join-Path $HOME ".config\starship\starship.toml"

$starshipCmd = Get-Command starship -ErrorAction SilentlyContinue
if ($starshipCmd) {
    try {
        Invoke-Expression (& starship init powershell)
        Write-Status OK "Starship initialized (config: $($env:STARSHIP_CONFIG))"
    } catch {
        Write-Status WARN "Starship found but failed to initialize: $($_.Exception.Message)"
    }
} else {
    Write-Status WARN "Starship not found. Install from https://starship.rs for a better prompt."
}

# -----------------------------
# iperf helper
# -----------------------------
# Wrapper to your iperf3 script that passes through any args:
#   iperf-test -c 10.10.10.10 -t 10
function iperf-test {
    [CmdletBinding()]
    param([Parameter(ValueFromRemainingArguments=$true)][string[]]$Args)

    $scriptPath = "D:\Documents\home lab\powershell_scripts\iperf3-test.ps1"
    if (Test-Path -LiteralPath $scriptPath) {
        & $scriptPath @Args
    } else {
        Write-Status ERR "iperf script not found at: $scriptPath"
    }
}

# -----------------------------
# Module Imports (safe loading)
# -----------------------------
# Add or pin modules here. If version is specified, it's enforced.
$modulesToLoad = @(
    @{ Name='PSReadLine';      Version='2.3.6' }
    @{ Name='ImportExcel' }
    @{ Name='PSScriptAnalyzer' }
    @{ Name='Terminal-Icons' }
)

foreach ($m in $modulesToLoad) {
    $name = $m.Name
    $version = $m['Version']

    # Quick availability check
    $available = Get-Module -ListAvailable -Name $name
    if (-not $available) {
        Write-Status WARN "Module not found: $name  (Install-Module $name -Scope CurrentUser)"
        continue
    }

    # Build import params
    $params = @{
        Name  = $name
        Force = $true
        ErrorAction = 'Stop'
    }
    if ($version) { $params.RequiredVersion = $version }

    try {
        Import-Module @params
        if ($version) {
            Write-Status OK "Loaded module: $name (RequiredVersion $version)"
        } else {
            Write-Status OK "Loaded module: $name"
        }
    } catch {
        Write-Status ERR ("Failed to import {0}: {1}" -f $name, $_.Exception.Message)
    }
}

# -----------------------------
# Terminal-Icons Theme (optional)
# -----------------------------
# Only apply if the module/cmdlet exists
if (Get-Command Set-TerminalIconsTheme -ErrorAction SilentlyContinue) {
    try {
        Set-TerminalIconsTheme -ColorTheme DevBlackOps
        Write-Status OK "Terminal-Icons theme set: DevBlackOps"
    } catch {
        Write-Status WARN "Could not set Terminal-Icons theme: $($_.Exception.Message)"
    }
}

# -----------------------------
# PSReadLine Options (if available)
# -----------------------------
if (Get-Module -Name PSReadLine) {
    try {
        Set-PSReadLineOption -PredictionSource History
        Set-PSReadLineOption -PredictionViewStyle ListView
        Set-PSReadLineOption -EditMode Windows
        Set-PSReadLineOption -MaximumHistoryCount 5000
        Set-PSReadLineOption -HistorySearchCursorMovesToEnd
        Write-Status OK "PSReadLine options configured."
    } catch {
        Write-Status WARN "Failed to set PSReadLine options: $($_.Exception.Message)"
    }
} else {
    Write-Status INFO "PSReadLine not loaded—skipping option tuning."
}

# -----------------------------
# Linux-like helpers: id / groups
# -----------------------------
# `id` prints uid/gid/groups in a Linux-ish style for the current user.
function id {
    try {
        $user = [System.Security.Principal.WindowsIdentity]::GetCurrent()
        $name = $user.Name

        # UID: last RID portion of the SID
        $uid  = ($user.User.Value -split '-')[-1]

        # Best-effort primary group name:
        # Windows doesn't expose "primary group" directly via this API the way Linux does.
        # We'll try to use the first token group, translating to NTAccount, and fall back to SID.
        $primaryGroupSid = $user.Groups | Select-Object -First 1
        $primaryGroup = try {
            $primaryGroupSid.Translate([System.Security.Principal.NTAccount]).Value
        } catch {
            $primaryGroupSid.Value
        }
        $gidName = ($primaryGroup -split '\\')[-1]
        $gid  = ($primaryGroupSid.Value -split '-')[-1]

        # Flatten all groups to a comma-separated list of friendly names, falling back to SIDs on translation errors.
        $groups = $user.Groups | ForEach-Object {
            try { $_.Translate([System.Security.Principal.NTAccount]).Value.Split('\')[-1] }
            catch { $_.Value }
        }
        $groupList = $groups -join ","

        Write-Output "uid=$uid($name) gid=$gid($gidName) groups=$groupList"
    } catch {
        Write-Status ERR "id: $($_.Exception.Message)"
    }
}

# `groups` prints space-separated group names for the current user.
function groups {
    try {
        $user = [System.Security.Principal.WindowsIdentity]::GetCurrent()
        $groups = $user.Groups | ForEach-Object {
            try { $_.Translate([System.Security.Principal.NTAccount]).Value.Split('\')[-1] }
            catch { $_.Value }
        }
        $groups -join " "
    } catch {
        Write-Status ERR "groups: $($_.Exception.Message)"
    }
}

# -----------------------------
# Optional Quality-of-life Aliases (uncomment if you want them)
# -----------------------------
# Set-Alias ll Get-ChildItem
# Set-Alias la "Get-ChildItem -Force"
# Set-Alias which Get-Command
# function cat { param([Parameter(Mandatory)][string]$Path) Get-Content -Path $Path }

# End of profile
