{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    bat
    brightnessctl
    coreutils
    difftastic
    docker-compose
    dua
    eza
    fd
    ffmpeg
    file
    fzf
    git
    gnumake
    gnupg
    htop
    ipmitool
    jq
    libnotify
    lm_sensors
    lshw
    neofetch
    nmap
    ouch
    pasystray
    pavucontrol
    qemu
    ripgrep
    smartmontools
    tmux
    tree
    tree
    unzip
    watch
    wget
    zip
    zoxide
  ];
}
