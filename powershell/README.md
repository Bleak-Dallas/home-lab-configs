# PowerShell Configuration

This folder contains PowerShell profile and related configuration for your environment.

## Files

- `Microsoft.PowerShell_profile.ps1` — Main PowerShell profile script loaded for the current user.
- `Modules/` — Optional custom modules or helper scripts loaded by the profile (if present).

## Installation / Usage

1. Determine your PowerShell profile path:
   ```powershell
   $PROFILE
   ```
2. Link or copy the profile script:
   - Set your profile to use this repo’s profile:
     ```powershell
     New-Item -ItemType Directory -Force (Split-Path $PROFILE)
     Copy-Item -Force "<repo-path>\powershell\Microsoft.PowerShell_profile.ps1" $PROFILE
     ```
   - Or symlink (Windows 10+):
     ```powershell
     New-Item -ItemType Directory -Force (Split-Path $PROFILE)
     New-Item -ItemType SymbolicLink -Path $PROFILE -Target "<repo-path>\powershell\Microsoft.PowerShell_profile.ps1" -Force
     ```

## Optional Integrations

- Starship prompt: ensure Starship is installed and your profile contains:
  ```powershell
  Invoke-Expression (& starship init powershell)
  ```
- PSReadLine: install and import for enhanced editing:
  ```powershell
  Install-Module PSReadLine -Scope CurrentUser -Force
  Import-Module PSReadLine
  ```

## Notes

- Replace `<repo-path>` with the absolute path to this repository on your system.
- If you maintain separate profiles for Windows PowerShell and PowerShell (Core), duplicate or adapt as needed:
  - Windows PowerShell: `Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1`
  - PowerShell (Core): `Documents\PowerShell\Microsoft.PowerShell_profile.ps1`
