{ pkgs, unstablePkgs, config, rose-pine-cursor, inputs, ... }:
{
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    config = {
      common.default = [ "gtk" ];
      hyprland.default = [ "gtk" "hyprland" ];
    };

    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
  };
  xdg.configFile."hypr/movefocus.sh".source = ./hy3-movefocus.sh;
  xdg.configFile."swappy/config".text = ''
    [Default]
    save_dir=$HOME/Pictures/Screenshots
    save_filename_format=swappy-%Y%m%d-%H%M%S.png
    show_panel=true
    line_size=8
    text_size=24
    text_font=sans-serif
    paint_mode=brush
    early_exit=true
    fill_shape=false
  '';

  wayland.windowManager.hyprland = {
    # Ex: https://github.com/vimjoyer/nixconf/blob/main/homeManagerModules/features/hyprland/default.nix
    # Ex with ${pkg}/bin/[binary] mapping example: https://github.com/Misterio77/nix-config/blob/main/home/misterio/features/desktop/hyprland/default.nix
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    enable = true;
    xwayland.enable = true;
    systemd.variables = [ "--all" ];

    plugins = [
      inputs.hy3.packages.${pkgs.system}.hy3
      # unstablePkgs.hyprlandPlugins.hy3
      # (unstablePkgs.hyprlandPlugins.hy3.override {
      #   hyprland = inputs.hyprland.packages.${pkgs.system}.hyprland;
      # })
      # Hyprfocus compilation broken until: https://github.com/pyt0xic/hyprfocus/pull/1 merged
      # inputs.hyprfocus.packages.${pkgs.system}.hyprfocus
    ];

    settings = {
      debug = {
        disable_logs = true;
      };
      xwayland = {
        force_zero_scaling = true;
      };
      monitor = ",preferred,auto,auto";

      env = [
        "HYPRCURSOR_THEME,rose-pine-hyprcursor"
      ];
      input = {
        kb_layout = "us";
        kb_options = "caps:escape";

        follow_mouse = 2;
        accel_profile = "adaptive";
        # sensitivity = 0;
      };
      exec = [
        "${unstablePkgs.swayosd}/bin/swayosd-server"
      ];
      exec-once = [
        # "mkchromecast -t"
        "1password --enable-features=WaylandWindowDecorations --ozone-platform-hint=auto  --silent"
        # "${pkgs.blueberry}/bin/blueberry-tray"
        "${pkgs.blueman}/bin/blueman-applet"
        "${pkgs.swaybg}/bin/swaybg -m fill -i ~/.config/hypr/wallpaper.png"
        # "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"

        # "${pkgs.xorg.xprop}/bin/xprop -root -f _XWAYLAND_GLOBAL_OUTPUT_SCALE 24c -set _XWAYLAND_GLOBAL_OUTPUT_SCALE 2"
        # "hyprctl setcursor \"BreezeX-RosePine-Linux\" 24"
      ];
      general = {
        gaps_in = 10;
        gaps_out = 20;
        border_size = 6;
        "col.active_border" = "rgb(11111b) rgb(181825) 45deg";
        "col.inactive_border" = "rgba(f5e0dc20)";

        no_focus_fallback = true;

        # layout = "master";
        layout = "hy3";
        resize_on_border = true;
      };
      decoration = {
        rounding = 4;
        active_opacity = "0.96";
        inactive_opacity = "0.90";
        fullscreen_opacity = "1.0";

        dim_inactive = true;
        dim_strength = "0.05";

        drop_shadow = false;

        blur = {
          enabled = true;
          xray = true;
          size = 5;
          passes = 2;
          ignore_opacity = true;
          new_optimizations = true;
        };
      };
      group = {
        "col.border_active" = "rgb(11111b) rgb(181825) 45deg";
        "col.border_inactive" = "rgba(f5e0dc20)";

        groupbar = {
          render_titles = false;
          height = 2;
          "col.active" = "rgb(181825)";
          "col.inactive" = "rgba(f5e0dc20)";
        };
      };
      animations = {
        enabled = "yes";
        bezier = [
          "myBezier, 0.05, 0.9, 0.1, 1.05"
          "linear, 0.0, 0.0, 1.0, 1.0"
          "wind, 0.05, 0.9, 0.1, 1.05"
          "winIn, 0.1, 1.1, 0.1, 1.1"
          "winOut, 0.3, -0.3, 0, 1"
          "slow, 0, 0.85, 0.3, 1"
          "overshot, 0.7, 0.6, 0.1, 1.1"
          "bounce, 1.1, 1.6, 0.1, 0.85"
          "sligshot, 1, -1, 0.15, 1.25"
          "nice, 0, 6.9, 0.5, -4.20"
        ];

        animation = [
          "windowsIn, 1, 5, slow, popin"
          "windowsOut, 1, 5, winOut, popin"
          "windowsMove, 1, 5, wind, slide"
          "border, 1, 10, linear"
          "borderangle, 1, 180, linear, loop #used by rainbow borders and rotating colors"
          "fade, 1, 5, overshot"
          "workspaces, 1, 5, wind"
          "windows, 1, 5, bounce, popin"
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
        # focus_on_activate = true;
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
        "float, viewnior"
        "float, feh"
        "float, pavucontrol-qt"
        "float, pavucontrol"
        "float, file-roller"
      ];
      windowrulev2 = [
        "float, title:wlogout"
        "float, title:Annotator"
        "fullscreen, title:wlogout"
        "noshadow, floating:1"
        "dimaround, class:^(gcr-prompter)$"
        "dimaround, class:^(xdg-desktop-portal-gtk)$"
        "dimaround, class:^(polkit-gnome-authentication-agent-1)$"

        # throw sharing indicators away
        "workspace special silent, title:^(Firefox — Sharing Indicator)$"
        "workspace special silent, title:^(.*is sharing (your screen|a window)\.)$"

        # GitButler Float
        "float, class:^(git-butler.*)$"

        # 1Password
        # "noinitialfocus,title:Quick Access - 1Password,floating"
        "stayfocused,title:Quick Access - 1Password,floating:1"
        "forceinput,title:Quick Access - 1Password,floating:1"
        "dimaround,title:Quick Access - 1Password,floating:1"

        # "center, class:^(1Password)$"
        # "stayfocused,class:^(1Password)$"

        # idle inhibit while watching videos
        "idleinhibit focus, class:^(vivaldi)$, title:^(.*YouTube.*)$"
        "idleinhibit fullscreen, class:^(vivaldi)$"

        # float/slidein Beeper AppImage
        "animation fadeIn, class:Beeper"
        "size 1200 800, class:Beeper"
        "center, class:Beeper"
        "float, class:Beeper"

        # float/slidein gnome-text-editor
        "animation slide, class:org.gnome.TextEditor"
        "float, class:org.gnome.TextEditor"

        # float/slidein nemo file manager
        "animation slide, class:nemo"
        "float, class:nemo"
        "center, class:nemo"

        # float/slidein pavucontrol
        "animation slide, class:pavucontrol"
        "float, class:pavucontrol"
        "center, class:pavucontrol"

        # float/slidein blueberry
        "animation slide, class:^(.*blueberry.*)$"
        "float, class:^(.*blueberry.*)$"
        "center, class:^(.*blueberry.*)$"

        # float/slidein blueman-manager
        "animation slide, class:^(.*blueman-.*)$"
        "float, class:^(.*blueman-.*)$"
        "center, class:^(.*blueman-.*)$"

        # float/slidein engrampa
        "animation slide, class:engrampa"
        "float, class:engrampa"
        "size 30% 40%, class:engrampa"
        "center, class:engrampa"

        # gtk file chooser
        "float, class:xdg-desktop-portal-gtk, title:All Files"
        "size 30% 50%, class:xdg-desktop-portal-gtk, title:All Files"
        "center, class:xdg-desktop-portal-gtk, title:All Files"

        # float imv
        "animation slide, class:imv"
        "float, class:imv"

        # float/slidein network-manager-editor
        "animation slide, class:nm-connection-editor"
        "float, class:nm-connection-editor"
        "center, class:nm-connection-editor"

        # opensnitch
        "float, class:^(opensnitch_ui)$"
        "dimaround, class:^(opensnitch_ui)$"

        # DevTools
        "float, title:^(DevTools.*)$"
        "float, title:^(DevTools.*)$"
        "float, title:^(Developer Tools.*)$"
        "float, title:^(Developer Tools.*)$"
        "size 30% 60%, title:^(DevTools.*)$"
        "size 30% 60%, title:^(Developer Tools.*)$"

        # Winetricks
        "float, title:^(Winetricks.*)$"

        # Lutris
        "float, class:lutris"

        # Beekeeper-Studio
        "float, class:beekeeper-studio"

        # Sharing indicator
        "animation slide, title:^.*(Sharing Indicator).*$"
        "float, title:^.*(Sharing Indicator).*$"
        "move 50% 100%-100, title:^.*(Sharing Indicator).*$"

        "animation slide, title:^.*(sharing your screen).*$"
        "float, title:^.*(sharing your screen).*$"
        "move 50% 100%-100, title:^(.*sharing your screen.*)$"

        # polkit
        "dimaround, class:^(xdg-desktop-portal-gtk)$"
        "dimaround, class:^(polkit-gnome-authentication-agent-1)$"
        "float, class:^(gcr-prompter)$"
        "dimaround, class:^(gcr-prompter)$"
        "float, class:^(org.freedesktop.impl.portal.desktop.kde)$"
        "size 1000 700, class:^(org.freedesktop.impl.portal.desktop.kde)$"
        "center, class:^(org.freedesktop.impl.portal.desktop.kde)$"
        "dimaround, class:^(org.freedesktop.impl.portal.desktop.kde)$"
        "float, class:^(org.kde.polkit-kde-authentication-agent-1)$"
        "dimaround, class:^(org.kde.polkit-kde-authentication-agent-1)$"

        # xwaylandvideobridge - https://wiki.hyprland.org/Useful-Utilities/Screen-Sharing/#xwayland
        "opacity 0.0 override 0.0 override,class:^(xwaylandvideobridge)$"
        "noanim,class:^(xwaylandvideobridge)$"
        "nofocus,class:^(xwaylandvideobridge)$"
        "noinitialfocus,class:^(xwaylandvideobridge)$"
      ];
      bind = [
        # hy3
        "$mainMod, G, hy3:makegroup, tab, force_ephemeral"
        "$mainMod, Y, hy3:changegroup, opposite"
        "$mainMod, Q, hy3:killactive,"

        # "$mainMod, G, togglegroup,"
        # "$mainMod, U, changegroupactive,b"
        # "$mainMod, I, changegroupactive,f"
        "$mainMod, Q, killactive"
        "CTRL SHIFT, L, exec, swaylock -f"
        "$mainMod, Return, exec, wezterm"
        "$mainMod SHIFT, R, exec, hyprctl reload"
        "$mainMod SHIFT, F, exec, nemo"
        "$mainMod SHIFT, Q, exec, wlogout -b 5 -c 0 -r 0 -m 0 --protocol layer-shell"
        "$mainMod SHIFT, Space, togglefloating,"
        "$mainMod, Space, cyclenext # hack to focus floating windows"
        "$mainMod, F, fullscreen, 1 # fullscreen type 1"
        "$mainMod, P, pseudo, # dwindle layout"
        "$mainMod, O, togglesplit, # dwindle layout"
        "$mainMod, D, exec, \"$HOME/.config/rofi/bin/launcher\""
        "$mainMod, E, exec, \"$HOME/.config/rofi/bin/emoji\""
        "$mainMod, C, exec, \"$HOME/.config/rofi/bin/cliphist\""
        "$mainMod, S, exec, \"$HOME/.config/rofi/bin/screenshot\""
        "$mainMod SHIFT, S, exec, pkill --signal SIGINT wf-recorder && notify-send \"Stopped Recording\" || wf-recorder -g \"$(slurp)\" -f ~/Videos/wfrecording_$(date +\"%Y-%m-%d_%H:%M:%S.mp4\") & notify-send \"Started Recording\" # start/stop video recording"

        # swaynotificationcenter
        "CTRL, Space, exec, swaync-client -t -sw"
        "CTRL SHIFT, Space, exec, swaync-client -C -sw"

        # Move focus with mainMod + arrow keys
        # "$mainMod, H, movefocus, l"
        # "$mainMod, L, movefocus, r"
        # "$mainMod, K, movefocus, u"
        # "$mainMod, J, movefocus, d"
        # "$mainMod SHIFT, H, movewindow, l"
        # "$mainMod SHIFT, L, movewindow, r"
        # "$mainMod SHIFT, K, movewindow, u"
        # "$mainMod SHIFT, J, movewindow, d"
        # "$mainMod SHIFT, J, movewindoworgroup, d"

        # hy3 - Move focus with mainMod + arrow keys
        "$mainMod, H, exec, /home/ndo/.config/hypr/movefocus.sh l"
        "$mainMod, L, exec, /home/ndo/.config/hypr/movefocus.sh r"
        "$mainMod, K, hy3:movefocus, u"
        "$mainMod, J, hy3:movefocus, d"
        "$mainMod SHIFT, H, hy3:movewindow, l"
        "$mainMod SHIFT, L, hy3:movewindow, r"
        "$mainMod SHIFT, K, hy3:movewindow, u"
        "$mainMod SHIFT, J, hy3:movewindow, d"

        # Special Keys
        ",XF86MonBrightnessUp, exec, brightnessctl set 5%+"
        ",XF86MonBrightnessDown, exec, brightnessctl set 5%-"

        ",XF86AudioPlay, exec, playerctl play-pause"
        ",XF86AudioNext, exec, playerctl next"
        ",XF86AudioPrev, exec, playerctl previous"
        ",XF86AudioStop, exec, playerctl stop"

        # ",code:115, exec, swayosd-client --output-volume raise"
        # ",code:114, exec, swayosd-client --output-volume lower"
        # ",code:113, exec, swayosd-client --output-volume mute-toggle"

        # SwayOSD + AudioControl
        ",XF86AudioRaiseVolume, exec, swayosd-client --output-volume raise"
        ",XF86AudioLowerVolume, exec, swayosd-client --output-volume lower"
        ",XF86AudioMute, exec, swayosd-client --output-volume mute-toggle"
        ",XF86AudioMicMute, exec, swayosd-client --input-volume mute-toggle"
      ]
      ++ (
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
        "CTRL SHIFT, Period, exec, 1password --enable-features=WaylandWindowDecorations --ozone-platform-hint=auto --quick-access"
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
      binde = , H, resizeactive, 40 0
      binde = , L, resizeactive, -40 0
      binde = , K, resizeactive, 0 -40
      binde = , J, resizeactive, 0 40
      bind = , escape, submap, reset
      submap = reset

      plugin {
        hy3 {
          tabs {
            height = 5
            padding = 8
            render_text = false
            col.active = rgb(8a8dcc)
          }
          autotile {
            enable = true
            trigger_width = 800
            trigger_height = 500
          }
        }
        # hyprfocus {
        #   enabled = yes
        #
        #   focus_animation = shrink
        #
        #   bezier = bezIn, 0.5,0.0,1.0,0.5
        #   bezier = bezOut, 0.0,0.5,0.5,1.0
        #
        #   flash {
        #       flash_opacity = 0.8
        #
        #       in_bezier = bezIn
        #       in_speed = 0.5
        #
        #       out_bezier = bezOut
        #       out_speed = 3
        #   }
        #
        #   shrink {
        #     shrink_percentage = 0.995
        #
        #     in_bezier = bezIn
        #     in_speed = 0.25
        #
        #     out_bezier = bezOut
        #     out_speed = 1
        #   }
        # }
      }
    '';
  };
}
