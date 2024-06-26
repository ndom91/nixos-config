{ rose-pine-cursor, config, lib, unstablePkgs, inputs, pkgs, ... }:
{
  imports = with rose-pine-cursor pkgs inputs; [
    ./hyprland/default.nix
    ./waybar/default.nix
    ./rofi/default.nix
    ./swaylock.nix
    ./swaync.nix
    ./wlogout.nix
  ];

  home.sessionVariables = {
    # WLR_RENDERER_ALLOW_SOFTWARE = "1"; # Required for VMs
    SDL_VIDEODRIVER = "wayland";

    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_DESKTOP = "Hyprland";

    HYPRLAND_LOG_WLR = "1";
    GDK_BACKEND = "wayland,x11";

    XCURSOR_SIZE = "24";

    # NixOS force Wayland for some apps
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    # Make qt apps expect wayland
    QT_QPA_PLATFORM = "wayland";

    # fix modals from being attached on tiling wms
    _JAVA_AWT_WM_NONREPARENTING = "1";
    # fix java gui antialiasing
    _JAVA_OPTIONS = "-Dawt.useSystemAAFontSettings=lcd";
  };

  services = {
    cliphist.enable = true;
    wlsunset = {
      enable = true;
      latitude = "52.52";
      longitude = "13.40";
      temperature = {
        day = 6500;
        night = 4500;
      };
    };
    swayidle = {
      enable = true;
      timeouts = [
        {
          timeout = 595;
          command = "${pkgs.libnotify}/bin/notify-send 'Locking in 5 seconds' -t 5000";
        }
        {
          timeout = 600;
          command = "${config.programs.swaylock.package}/bin/swaylock";
        }
        {
          timeout = 660;
          command = "${inputs.hyprland.packages.${pkgs.system}.hyprland}/bin/hyprctl dispatch dpms off";
          resumeCommand = "${inputs.hyprland.packages.${pkgs.system}.hyprland}/bin/hyprctl dispatch dpms on";
        }
        {
          timeout = 3600;
          command = "${pkgs.systemd}/bin/systemctl suspend-then-hibernate";
        }
      ];
      events = [
        {
          event = "before-sleep";
          command = "${config.programs.swaylock.package}/bin/swaylock";
        }
      ];
    };
  };

  home.packages = with pkgs; [
    # blueberry
    evtest
    mkchromecast
    playerctl
    swaybg
    unstablePkgs.swaynotificationcenter
    unstablePkgs.swayosd
    wdisplays
    wev
    wf-recorder
    wl-clipboard
    wl-mirror
    wlr-randr

    # Screenshot
    grim
    slurp
    swappy
  ];
}
