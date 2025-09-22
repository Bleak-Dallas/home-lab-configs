# Fastfetch Configuration

This folder contains configuration for Fastfetch, a fast and lightweight system information tool.

## Files

- `config.jsonc` — Fastfetch config with modules, ordering, and formatting.

## Setup

1. Install Fastfetch from the official repo/binaries.
2. Place or point Fastfetch to this config:
   - Default config path (Windows): `%APPDATA%\fastfetch\config.jsonc`
   - Default config path (Linux/macOS): `~/.config/fastfetch/config.jsonc`
   - Or set `FASTFETCH_CONFIG` to the full path of your config file.
3. Copy or symlink this repo’s config into the appropriate path.

## Usage

- Run Fastfetch from your terminal:
  ```sh
  fastfetch
  ```
- To use a specific config file directly:
  ```sh
  fastfetch --config "<repo-path>/fasfetch/config.jsonc"
  ```

## Notes

- Adjust modules and icons based on your terminal font/icon support.
- Keep OS-specific configs (e.g., `config.windows.jsonc`, `config.linux.jsonc`) if you need different layouts and select via `--config` or `FASTFETCH_CONFIG`.
