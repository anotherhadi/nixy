{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    unzip
    ripgrep
    wget
    libva
    qt5ct
    stow
    blueman
    gcc
    peaclock
    alejandra
    libnotify
    xdg_utils
    tldr
  ];
}
