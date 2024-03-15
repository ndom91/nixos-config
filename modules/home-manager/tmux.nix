{ pkgs, config, lib, unstablePkgs, input, ... }:
let
  pythonInputs = (pkgs.python3.withPackages (p: with p; [
    libtmux
    pip
  ]));
  tmux-window-name = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "tmux-window-name";
    version = "2024-03-08";
    src = pkgs.fetchFromGitHub {
      owner = "ofirgall";
      repo = "tmux-window-name";
      rev = "34026b6f442ceb07628bf25ae1b04a0cd475e9ae";
      sha256 = "sha256-BNgxLk/BkaQkGlB4g2WKVs39y4VHL1Y2TdTEoBy7yo0=";
    };
    nativeBuildInputs = [ pkgs.makeWrapper ];
    rtpFilePath = "tmux_window_name.tmux";
    postInstall = ''
      sed -i "s|^USR_BIN_REMOVER.*|USR_BIN_REMOVER = (r\'^/home/${config.home.username}/.nix-profile/bin/(.+)( --.*)?\', r\'\\\g<1>\')|" $target/scripts/rename_session_windows.py
      for f in tmux_window_name.tmux scripts/rename_session_windows.py; do
        wrapProgram $target/$f \
          --prefix PATH : ${lib.makeBinPath [pythonInputs]}
      done
    '';
  };
in
{
  programs.tmux = {
    enable = true;
    package = unstablePkgs.tmux;
    clock24 = true;
    keyMode = "vi";
    newSession = true;
    historyLimit = 10000;
    prefix = "C-a";
    plugins = [
      tmux-window-name
      pkgs.tmuxPlugins.mode-indicator
      {
        plugin = pkgs.tmuxPlugins.catppuccin;
        extraConfig = ''
          set -g @catppuccin_flavour 'mocha'

          set -g @catppuccin_user off
          set -g @catppuccin_host off
          set -g @catppuccin_date_time "%Y-%m-%d %H:%M"

          set -g @catppuccin_window_left_separator "█"
          set -g @catppuccin_window_right_separator "█"
          set -g @catppuccin_window_number_position "right"
          set -g @catppuccin_window_middle_separator "  █"
          set -g @catppuccin_window_status_enable "no"
          set -g @catppuccin_window_default_fill "number"
          set -g @catppuccin_window_default_text "#W"
          set -g @catppuccin_window_current_fill "number"
          set -g @catppuccin_window_current_text "#W"

          set -g @catppuccin_status_modules_left "application date_time"
          set -g @catppuccin_status_modules_right "prefix_highlight"
          set -g @catppuccin_status_left_separator "█"
          set -g @catppuccin_status_right_separator "█ "
          set -g @catppuccin_status_right_separator_inverse "no"
          set -g @catppuccin_status_fill "all"
          set -g @catppuccin_status_connect_separator "no"

          set -g @tmux_window_name_log_level "'DEBUG'"
          set -g @tmux_window_name_dir_substitute_sets "[('/home/${config.home.username}/.nix-profile/bin/(.+) --.*', '\\g<1>')]"
          set -g @tmux_window_dir_programs "['nvim', 'vim', 'vi', 'git', '/home/${config.home.username}/.nix-profile/bin/nvim']"
        '';
      }
      # {
      #   plugin = pkgs.tmuxPlugins.tmux-thumbs;
      #   extraConfig = ''
      #     set -g @thumbs-command 'echo -n {} | wl-copy'
      #   '';
      # }
    ];
    extraConfig = ''
      # Quick escape back to insert mode in nvim
      set -sg escape-time 10

      # Setup 'v' to begin selection as in Vim
      bind-key -T edit-mode-vi Up send-keys -X history-up
      bind-key -T edit-mode-vi Down send-keys -X history-down
      unbind-key -T copy-mode-vi Space     ;   bind-key -T copy-mode-vi v send-keys -X begin-selection
      unbind-key -T copy-mode-vi Enter     ;   bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "reattach-to-user-namespace xclip"
      unbind-key -T copy-mode-vi C-v       ;   bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
      unbind-key -T copy-mode-vi [         ;   bind-key -T copy-mode-vi [ send-keys -X begin-selection
      unbind-key -T copy-mode-vi ]         ;   bind-key -T copy-mode-vi ] send-keys -X copy-selection

      # for nested tmux sessions
      set -g prefix C-a
      bind-key a send-prefix 

      setw -g aggressive-resize on

      # basic settings
      set-window-option -g xterm-keys on # for vim
      set-window-option -g monitor-activity on
      # use mouse # More on mouse support http://floriancrouzat.net/2010/07/run-tmux-with-mouse-support-in-mac-os-x-terminal-app/
      set -g history-limit 30000
      set -g mouse on


      # start panes at 1 - 0 is too far away :)
      set -g base-index 1
      set -g pane-base-index 1
      set-window-option -g pane-base-index 1
      set-option -g renumber-windows on

      # Undercurl
      set -g default-terminal "xterm-256color"
      set -as terminal-overrides ',*:Smulx=\E[4::%p1%dm'  # undercurl support
      set -as terminal-overrides ',*:Setulc=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m'  # underscore colours - needs tmux-3.0

      # FZF-TMUX WINDOW SWITCH
      bind-key    -T prefix s                choose-tree
      bind-key    -T prefix W                choose-window
      bind        -T prefix w                run-shell -b "$HOME/.dotfiles/scripts/tmux-switch-panes.sh"

      # Titles (window number, program name, active (or not))
      set-option -g set-titles on
      set-option -g set-titles-string '#H #W'

      # Unbinds
      unbind j
      unbind C-b # unbind default leader key
      unbind '"' # unbind horizontal split
      unbind %   # unbind vertical split

      # reload tmux conf
      bind-key r source-file ~/.config/tmux/tmux.conf \; display-message "~/.config/tmux/tmux.conf reloaded"

      # new split in current pane (horizontal / vertical)
      bind-key c split-window -v # split pane horizontally
      bind-key v split-window -h # split pane vertically

      # windows
      bind-key m new-window
      bind C-j previous-window
      bind C-k next-window
      bind-key C-a last-window # C-a C-a for last active window
      bind A command-prompt "rename-window %%"

      # use the vim motion keys to move between panes
      bind-key h select-pane -L
      bind-key j select-pane -D
      bind-key k select-pane -U
      bind-key l select-pane -R

      # Resizing
      bind-key C-h resize-pane -L 5
      bind-key C-j resize-pane -D 5
      bind-key C-k resize-pane -U 5
      bind-key C-l resize-pane -R 5

      # use vim motion keys while in copy mode
      setw -g mode-keys vi

      # layouts
      bind o select-layout 4582,187x95,0,0[187x69,0,0,0,187x25,0,70,23]
      bind C-r rotate-window
    '';
  };
}
