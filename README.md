<img align="right" src="https://raw.githubusercontent.com/NixOS/nixos-artwork/master/logo/nix-snowflake.svg" width="64px" />

# NixOS Configs

## 🏗️Overview

Consists mostly of a rebuild of my [dotfiles](https://github.com/ndom91/dotfiles) into a flake and a few other nixos related configurations.

## 📦 Packages

- `modules/home-manager` - Configuration for my user(s) home dir and xdg config (`~/.config`) settings
- `hosts/common` - Common system packages, system configs like shell aliases and tmux config
- `hosts/*` - Host specific configurations
- `flake.nix` - Starting point for the flake

## 📝 License

MIT
