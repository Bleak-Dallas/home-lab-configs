# Home Lab Configs

Personal, version-controlled configuration files for my home lab environment across Windows and cross‑platform tools. This repo helps keep shell, prompt, and utility configs consistent across machines.

## Structure

- `powershell/` — PowerShell user profile and related scripts.
- `starship/` — Starship prompt configuration (Windows-focused).
- `fastfetch/` — Fastfetch system info configuration.
- `espanso/` — Espanso text expander configuration and matches.

## Machines

- Win11 (Windows 11)
  - Uses Windows-specific config paths.
  - Separate configs where noted, e.g., `starship/starship.windows.toml`.
- Ubuntu Desktop
  - Linux config paths under `~/.config`.
  - Separate configs, e.g., `starship/starship.linux.toml` (create if needed).
- Ubuntu Server
  - Headless-focused; same Linux paths as Desktop.
  - Consider minimal prompt/modules for SSH and low-latency sessions.

## Quick Start

1. Clone this repo to a convenient location.
2. Configure each tool to use the files in this repo (copy or symlink):
   - PowerShell: set `$PROFILE` to `powershell/Microsoft.PowerShell_profile.ps1` (copy/symlink).
   - Starship: choose OS-specific config (copy or symlink):
     - Windows 11: `starship/starship.windows.toml` → `~/.config/starship.toml` (or set `STARSHIP_CONFIG`).
     - Ubuntu Desktop/Server: `starship/starship.linux.toml` → `~/.config/starship.toml`.
   - Fastfetch: use OS-specific config if you maintain separate ones (copy or symlink):
     - Windows 11: `%APPDATA%/fastfetch/config.jsonc`
     - Ubuntu Desktop/Server: `~/.config/fastfetch/config.jsonc`
   - Espanso: copy/symlink contents of `espanso/` into your Espanso config directory.

## Default Config Paths

- PowerShell (Core): `~/Documents/PowerShell/Microsoft.PowerShell_profile.ps1`
- Windows PowerShell: `~/Documents/WindowsPowerShell/Microsoft.PowerShell_profile.ps1`
- Starship: `~/.config/starship.toml` (Windows: `%USERPROFILE%/.config/starship.toml` or set `STARSHIP_CONFIG`)
- Fastfetch: `~/.config/fastfetch/config.jsonc` (Windows: `%APPDATA%/fastfetch/config.jsonc`)
- Espanso: `~/.config/espanso` (Windows: `%APPDATA%/espanso`)

## Tips

- Prefer symlinking so updates in this repo propagate automatically.
- Keep OS-specific variants (e.g., `*.windows.*`, `*.linux.*`) and switch via env vars or tool flags when needed.
- Avoid committing secrets; use environment variables, secure stores, or `.gitignore` for sensitive files.

## Maintenance

- After changes, reload/restart the respective tool:
  - PowerShell: start a new session or `.& $PROFILE`
  - Starship: `starship explain` to debug, or restart the shell
  - Fastfetch: run `fastfetch` to preview
  - Espanso: `espanso restart`

## Screenshots

Fastfetch examples from each environment:

- Windows 11: `fasfetch/Win11-fastfetch.png`
- Ubuntu Desktop (WSL shown): `fasfetch/WSL-fastfetch.png`
- Ubuntu Server: `fasfetch/Ubuntu-server-fastfetch.png`

If you prefer embedding images, move them under `docs/images/` and update references accordingly.
