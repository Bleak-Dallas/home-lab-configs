# Espanso Configuration

This folder contains configuration for Espanso, a cross‑platform text expander.

## Files

- `match/` — Custom match packs (YAML) defining triggers and replacements.
- `default.yml` or `config.yml` — Main Espanso configuration (if present).
- `packages/` — Optional local packages or overrides.

## Install

1. Install Espanso: https://espanso.org
2. Start the Espanso service/daemon once so it initializes config folders.

## Config Paths

- Windows: `%APPDATA%\espanso`
- Linux/macOS: `~/.config/espanso`

## Setup

Choose one of the following approaches:

1) Copy files
- Copy this repo's contents into your Espanso config directory.

2) Symlink (keeps repo as source of truth)
- Windows (PowerShell):
  ```powershell
  $src = "<repo-path>\espanso"
  $dst = "$env:APPDATA\espanso"
  New-Item -ItemType Directory -Force $dst | Out-Null
  New-Item -ItemType SymbolicLink -Path (Join-Path $dst 'match') -Target (Join-Path $src 'match') -Force
  # Repeat for other folders/files as needed
  ```
- Linux/macOS:
  ```sh
  SRC="<repo-path>/espanso"
  DST="$HOME/.config/espanso"
  mkdir -p "$DST"
  ln -sfn "$SRC/match" "$DST/match"
  # Repeat for other folders/files as needed
  ```

## Usage

- After updating config, restart Espanso:
  ```sh
  espanso restart
  ```
- Test a trigger in any text field to verify expansion.

## Notes

- Use separate files under `match/` for logical grouping (work, personal, dev snippets).
- For sensitive data, consider environment variables, vaults, or `.gitignore` to avoid committing secrets.
