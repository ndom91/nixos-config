{ pkgs, unstablePkgs, rose-pine-cursor, inputs, ... }:
{
  xdg.configFile."hypr/movefocus.sh".source = ./hy3-movefocus.sh;

  wayland.windowManager.hyprland = {
    # Ex: https://github.com/vimjoyer/nixconf/blob/main/homeManagerModules/features/hyprland/default.nix
    # Ex with ${pkg}/bin/[binary] mapping example: https://github.com/Misterio77/nix-config/blob/main/home/misterio/features/desktop/hyprland/default.nix
    package = unstablePkgs.hyprland;
    enable = true;
    # package = pkgs.hyprland;
    # systemd.enable = true;

    # reloadConfig = true;
    # systemdIntegration = true;
    # recommendedEnvironment = true;

    xwayland.enable = true;
    # hy3 not included in hyprland-plugins flake yet, see: https://github.com/hyprwm/hyprland-plugins
    # plugins = [
    #   inputs.hyprland-plugins.packages."${pkgs.system}".hy3
    # ];

    settings = {
      xwayland = {
        force_zero_scaling = true;
      };
      monitor = ",preferred,auto,auto";

      env = [
        "XCURSOR_SIZE,24"
        "MOZ_ENABLE_WAYLAND,1"
        "XDG_SESSION_TYPE,wayland"
        "QT_QPA_PLATFORM,wayland"
        # "VDPAU_DRIVER,radeonsi"
        # "LIBVA_DRIVER_NAME,radeonsi"
      ];
      input = {
        kb_layout = "us";
        kb_options = "caps:escape";

        # focus follow mouse
        follow_mouse = 2;
        accel_profile = "flat";

        touchpad = {
          natural_scroll = false;
          clickfinger_behavior = true;
        };

        sensitivity = 0;
      };
      exec-once = [
        # "${pkgs.waybar}/bin/.waybar-wrapped"
        # "gsettings set org.gnome.desktop.interface cursor-theme 'BreezeX-RosePine-Linux'"
        # "gsettings set org.gnome.desktop.interface cursor-size 24"

        # "mkchromecast -t"
        "swaync"
        "1password --enable-features=WaylandWindowDecorations --ozone-platform-hint=auto  --socket=wayland --silent"
        "swaybg -m fill -i ~/.config/hypr/wallpaper.png"
        "swayosd-server"
        "wl-paste --watch cliphist store"
        "wlsunset -l 52.50 -L 12.76 -t 4500 -T 6500"
        "blueberry-tray"
        "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"

        "xprop -root -f _XWAYLAND_GLOBAL_OUTPUT_SCALE 32c -set _XWAYLAND_GLOBAL_OUTPUT_SCALE 2"

        # "xsetroot -xcf ${rose-pine-cursor}/BreezeX-RosePine-Linux/cursors/left_ptr 24"
        "hyprctl setcursor \"BreezeX-RosePine-Linux\" 24"
      ];
      # plugin = {
      #   hy3 = {
      #     tabs = {
      #       height = 5;
      #       padding = 8;
      #       render_text = false;
      #       col.active = "rgb(8a8dcc)";
      #     };
      #     autotile = {
      #       enable = true;
      #       trigger_width = 800;
      #       trigger_height = 500;
      #     };
      #   };
      # };
      general = {
        gaps_in = 10;
        gaps_out = 20;
        border_size = 6;
        "col.active_border" = "rgb(11111b) rgb(181825) 45deg";
        "col.inactive_border" = "rgba(f5e0dc20)";

        # layout = "hy3";
        resize_on_border = true;
      };
      decoration = {
        rounding = "1";
        drop_shadow = false;
        active_opacity = "0.95";
        inactive_opacity = "0.80";
        fullscreen_opacity = "1.00";
        blur = {
          enabled = true;
          new_optimizations = true;
          xray = false;
          ignore_opacity = true;
          passes = 2;
          size = 5;
        };
      };
      animations = {
        enabled = "yes";
        bezier = [
          "smoothIn, 0.25, 1, 0.5, 1"
          "overshot, 0.05, 0.9, 0.1, 1.05"
          "smoothOut, 0.36, 0, 0.66, -0.56"
          "smoothIn, 0.25, 1, 0.5, 1"
        ];

        animation = [
          "windows, 1, 3, overshot"
          "windowsOut, 1, 4, smoothOut, slide"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 10, smoothIn"
          "fadeDim, 1, 10, smoothIn"
          "workspaces, 1, 6, default"
        ];
      };
      master = {
        new_is_master = true;
      };
      misc = {
        disable_hyprland_logo = true;
        animate_manual_resizes = true;
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = true;
      };
      windowrule = [
        "float, file_progress"
        "float, confirm"
        "float, dialog"
        "float, download"
        "float, notification"
        "float, error"
        "float, splash"
        "float, confirmreset"
        "float, title:Open File"
        "float, title:branchdialog"
        "float, Lxappearance"
        "float,viewnior"
        "float,feh"
        "float, pavucontrol-qt"
        "float, pavucontrol"
        "float, file-roller"
      ];
      windowrulev2 = [
        "float, title:wlogout"
        "float, title:Annotator"
        "fullscreen, title:wlogout"

        "noshadow, floating:1"
        "noshadow, class:flemozi"
        "noborder, class:flemozi"
        "noblur, class:flemozi"

        # idle inhibit while watching videos
        "idleinhibit focus, class:^(brave-browser)$, title:^(.*YouTube.*)$"
        "idleinhibit fullscreen, class:^(brave-browser)$"

        # Trufflehog Chrome extension
        "float, title:Trufflehog"

        # float/slidein nemo file manager
        "animation slide, class:nemo"
        "float, class:nemo"
        # "size 30% 40%, class:nemo
        "center, class:nemo"

        # float/slidein Flemoji
        "animation slide, title:Flemoji"
        "float, title:Flemoji"

        # float/slidein pavucontrol
        "animation slide, class:pavucontrol"
        "float, class:pavucontrol"
        "size 30% 30%, class:pavucontrol"
        "center, class:pavucontrol"

        # float/slidein blueberry
        "animation slide, class:^(.*blueberry.*)$"
        "float, class:^(.*blueberry.*)$"
        # "size 20% 40%, class:^(.*blueberry.*)$
        "center, class:^(.*blueberry.*)$"

        # float/slidein blueman-manager
        "animation slide, class:^(blueman-.*)$"
        "float, class:^(blueman-.*)$"
        "size 20% 40%, class:^(blueman-.*)$"
        "center, class:^(blueman-.*)$"

        # float/slidein engrampa
        "animation slide, class:engrampa"
        "float, class:engrampa"
        "size 30% 40%, class:engrampa"
        "center, class:engrampa"

        # float imv
        "animation slide, class:imv"
        "float, class:imv"

        # float/slidein network-manager-editor
        "animation slide, class:nm-connection-editor"
        "float, class:nm-connection-editor"
        # "size 20% 30%, class:nm-connection-editor
        "center, class:nm-connection-editor"

        # float/slidein wofi
        "animation slide, class:wofi"
        "float, class:wofi"
        # "size 20% 30%, class:wofi
        # "noshadow, class:wofi
        "noborder, class:wofi"
        "noblur, class:wofi"
        "move 1430 50, class:wofi"
        "dimaround, title:Search..."

        "float, class:^(opensnitch_ui)$"
        "dimaround, class:^(opensnitch_ui)$"
        "float, class:^(org.kde.polkit-kde-authentication-agent-1)$"
        "dimaround, class:^(org.kde.polkit-kde-authentication-agent-1)$"
        "float, class:^(gcr-prompter)$"
        "dimaround, class:^(gcr-prompter)$"
        "float, class:^(org.freedesktop.impl.portal.desktop.kde)$"
        "size 1000 700, class:^(org.freedesktop.impl.portal.desktop.kde)$"
        "center, class:^(org.freedesktop.impl.portal.desktop.kde)$"
        "dimaround, class:^(org.freedesktop.impl.portal.desktop.kde)$"

        # DevTools
        "float, class:brave-browser, title:^(DevTools.*)$"
        "float, title:^(DevTools.*)$"

        # Winetricks
        "float, title:^(Winetricks.*)$"

        # Lutris
        "float, class:lutris"

        # YAD (Fusion360)
        "float, class:yad"

        # Beekeeper-Studio
        "float, class:beekeeper-studio"

        # Sharing indicator
        "animation slide, title:^.*(Sharing Indicator).*$"
        "float, title:^.*(Sharing Indicator).*$"
        "move 50% 100%-100, title:^.*(Sharing Indicator).*$"

        "animation slide, title:^.*(sharing your screen).*$"
        "float, title:^.*(sharing your screen).*$"
        "move 50% 100%-100, title:^(.*sharing your screen.*)$"

        "dimaround, class:^(gcr-prompter)$"
        "dimaround, class:^(xdg-desktop-portal-gtk)$"
        "dimaround, class:^(polkit-gnome-authentication-agent-1)$"

        # fix xwayland apps
        "rounding 0, xwayland:1"
        "center, class:^(.*jetbrains.*)$, title:^(Confirm Exit|Open Project|win424|win201|splash)$"

        # xwaylandvideobridge - https://wiki.hyprland.org/Useful-Utilities/Screen-Sharing/#xwayland
        "opacity 0.0 override 0.0 override,class:^(xwaylandvideobridge)$"
        "noanim,class:^(xwaylandvideobridge)$"
        "nofocus,class:^(xwaylandvideobridge)$"
        "noinitialfocus,class:^(xwaylandvideobridge)$"
      ];
      bind = [
        # "$mainMod, T, hy3:makegroup, tab, force_ephemeral"
        # "$mainMod, Y, hy3:changegroup, opposite"
        "$mainMod, Q, killactive"
        # "$mainMod, Q, hy3:killactive,"
        "CTRL SHIFT, L, exec, swaylock -f"
        "$mainMod, Return, exec, wezterm"
        "$mainMod SHIFT, R, exec, hyprctl reload"
        "$mainMod SHIFT, F, exec, nemo"
        "$mainMod SHIFT, Q, exec, wlogout --protocol layer-shell"
        "$mainMod SHIFT, Space, togglefloating,"
        "$mainMod, Space, cyclenext # hack to focus floating windows"
        "$mainMod, F, fullscreen, 1 # fullscreen type 1"
        "$mainMod, P, pseudo, # dwindle layout"
        "$mainMod, O, togglesplit, # dwindle layout"
        "$mainMod, D, exec, \"$HOME/.config/rofi/bin/launcher\""
        "$mainMod, M, exec, \"$HOME/.config/rofi/bin/emoji\""
        "$mainMod, C, exec, \"$HOME/.config/rofi/bin/cliphist-img\""
        "$mainMod, S, exec, \"$HOME/.config/rofi/bin/screenshot\""
        "$mainMod SHIFT, S, exec, pkill --signal SIGINT wf-recorder && notify-send \"Stopped Recording\" || wf-recorder -g \"$(slurp)\" -f ~/Videos/wfrecording_$(date +\"%Y-%m-%d_%H:%M:%S.mp4\") & notify-send \"Started Recording\" # start/stop video recording"

        # notifications mako
        # "CTRL, `, exec, makoctl restore
        # "CTRL SHIFT, Space, exec, makoctl dismiss -a
        # "CTRL, Space, exec, makoctl dismiss

        # notifications swaync
        "CTRL, Space, exec, swaync-client -t -sw"
        "CTRL SHIFT, Space, exec, swaync-client -C -sw"

        # Move focus with mainMod + arrow keys
        "$mainMod, H, movefocus, l"
        "$mainMod, L, movefocus, r"
        "$mainMod, K, movefocus, u"
        "$mainMod, J, movefocus, d"
        # "$mainMod, H, exec, /home/ndo/.config/hypr/movefocus.sh l"
        # "$mainMod, L, exec, /home/ndo/.config/hypr/movefocus.sh r"
        # "$mainMod, K, hy3:movefocus, u"
        # "$mainMod, J, hy3:movefocus, d"

        # "$mainMod SHIFT, H, hy3:movewindow, l"
        # "$mainMod SHIFT, L, hy3:movewindow, r"
        # "$mainMod SHIFT, K, hy3:movewindow, u"
        # "$mainMod SHIFT, J, hy3:movewindow, d"
        "$mainMod SHIFT, H, movewindow, l"
        "$mainMod SHIFT, L, movewindow, r"
        "$mainMod SHIFT, K, movewindow, u"
        "$mainMod SHIFT, J, movewindow, d"

        # Special Keys
        ",XF86MonBrightnessUp, exec, brightnessctl set 5%+"
        ",XF86MonBrightnessDown, exec, brightnessctl set 5%-"

        ",XF86AudioPlay, exec, playerctl play-pause"
        ",XF86AudioNext, exec, playerctl next"
        ",XF86AudioPrev, exec, playerctl previous"
        ",XF86AudioStop, exec, playerctl stop"

        # SwayOSD + AudioControl
        ",XF86AudioRaiseVolume, exec, swayosd-client --output-volume raise"
        ",XF86AudioLowerVolume, exec, swayosd-client --output-volume lower"
        ",XF86AudioMute, exec, swayosd-client --output-volume mute-toggle"
        ",XF86AudioMicMute, exec, swayosd-client --input-volume mute-toggle"
      ]
      ++ (
        # workspaces
        # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
        builtins.concatLists (builtins.genList
          (
            x:
            let
              ws =
                let
                  c = (x + 1) / 10;
                in
                builtins.toString (x + 1 - (c * 10));
            in
            [
              "$mainMod, ${ws}, workspace, ${toString (x + 1)}"
              "$mainMod SHIFT, ${ws}, movetoworkspacesilent, ${toString (x + 1)}"
            ]
          )
          10)
      );
      bindn = [
        # 1Password Quick Search
        "CTRL SHIFT, Period, exec, 1password --quick-access"
      ];
      bindm = [
        # Move/resize windows with mainMod + LMB/RMB and dragging
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];
      "$mainMod" = "SUPER";
    };
    extraConfig = ''
      # Resize
      bind = $mainMod, R, submap, resize
      submap = resize
      binde = , H, resizeactive, -40 0
      binde = , L, resizeactive, 40 0
      binde = , K, resizeactive, 0 -40
      binde = , J, resizeactive, 0 40
      bind = , escape, submap, reset
      submap = reset
    '';
  };
}