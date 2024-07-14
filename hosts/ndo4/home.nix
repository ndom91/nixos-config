{ fira-sans-nerd-font, rose-pine-cursor, nix-colors, lib, inputs, config, pkgs, unstablePkgs, stateVersion, ... }:
{
  imports = with rose-pine-cursor inputs pkgs unstablePkgs; [
    nix-colors.homeManagerModules.default
    # User Packages
    ../../modules/home-manager/user-packages.nix
    # Programming Lanaguages
    ../../modules/home-manager/languages/node.nix
    ../../modules/home-manager/languages/rust.nix
    # Common
    ../../modules/home-manager/git.nix
    ../../modules/home-manager/tmux.nix
    ../../modules/home-manager/neofetch.nix
    ../../modules/home-manager/bash.nix
    ../../modules/home-manager/xdg.nix
    ../../modules/home-manager/dconf.nix
    ../../modules/home-manager/gtk/default.nix
    ../../modules/home-manager/starship.nix
    ../../modules/home-manager/neovim.nix
    ../../modules/home-manager/zathura.nix
    ../../modules/home-manager/wezterm.nix
    ../../modules/home-manager/alacritty.nix
    ../../modules/home-manager/wayland/default.nix
  ];
  home.username = "ndo";
  home.homeDirectory = "/home/ndo";
  home.stateVersion = stateVersion;
  home.packages = [
    inputs.home-manager.packages.x86_64-linux.home-manager # home-manager binary
    fira-sans-nerd-font
  ];

  # systemd.user.sessionVariables = config.home.sessionVariables;
  systemd.user.startServices = "sd-switch";

  # Themes - https://github.com/tinted-theming/base16-schemes
  colorScheme = nix-colors.colorSchemes.rose-pine;

  # ndo4 overrides
  wayland.windowManager.hyprland = {
    settings = {
      monitor = lib.mkForce [
        "DP-1,3440x1440,1080x480,1"
        "DP-2,1920x1080,0x0,1,transform,3"
      ];
      workspace = [
        "1,monitor:DP-2,default:true"
        "2,monitor:DP-1,default:true"
        "3,monitor:DP-1"
      ];
      exec-once = [
        "${pkgs.xorg.xprop}/bin/xprop -root -f _XWAYLAND_GLOBAL_OUTPUT_SCALE 24c -set _XWAYLAND_GLOBAL_OUTPUT_SCALE 1.5"
      ];
    };
  };

  home.file = {
    ".ripgreprc".source = ../../dotfiles/.ripgreprc;
    ".local/share/fonts" = {
      recursive = true;
      source = ./../../dotfiles/fonts;
    };

    ".config/hypr/wallpaper.png".source = ../../dotfiles/wallpapers/dark-purple-space-01.png;

    ".config/brave-flags.conf".source = ../../dotfiles/brave-flags.conf;
    ".config/electron-flags.conf".source = ../../dotfiles/electron-flags.conf;
  };

  services = {
    network-manager-applet.enable = false;
    syncthing.enable = true;
  };

  programs.atuin = {
    enable = true;
    settings = {
      auto_sync = false;
      style = "compact";
      history_filter = [
        "^cd"
        "^ll"
        "^n?vim"
      ];
      common_prefix = [ "sudo" "ll" "cd" "clear" "ls" "echo" "pwd" "exit" "history" ];
      secrets_filter = true;
      enter_accept = true;
    };
  };

  programs.vscode = {
    enable = true;
    package = unstablePkgs.vscodium;
    extensions = with unstablePkgs.vscode-extensions; [
      mvllow.rose-pine
      vscodevim.vim
      esbenp.prettier-vscode
      svelte.svelte-vscode
      rust-lang.rust-analyzer
    ];
  };

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };

  # Mostly for use with comma
  programs.nix-index = {
    enable = true;
    enableBashIntegration = true;
    package = pkgs.nix-index;
  };

  programs.home-manager.enable = true;
  programs.bash.enable = true;
  programs.zoxide = {
    enable = true;
    options = [
      "--cmd cd"
    ];
  };
}
