# Starship Configuration

This folder contains configuration files for the Starship prompt on Windows.

## Files

- `starship.windows.toml` — Starship configuration tailored for Windows shells (e.g., PowerShell). Place or symlink this file where your environment expects the Starship config.

## Usage

1. Install Starship: https://starship.rs
2. Point Starship to this config (choose one):
   - Set env var: `STARSHIP_CONFIG` to the full path of `starship.windows.toml`.
   - Or copy the file to your default config path (commonly `~/.config/starship.toml`).
3. Ensure your shell initializes Starship (example for PowerShell):
   ```powershell
   Invoke-Expression (& starship init powershell)
   ```

## Notes

- These settings are Windows-focused. If you use other OSes, consider creating corresponding configs (e.g., `starship.linux.toml`) and switching via `STARSHIP_CONFIG`.
- If you version control dotfiles, you can symlink this file into your config directory to keep things in sync.

