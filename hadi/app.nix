{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    firefox
    nextcloud-client
    obsidian
    chromium
    swappy
    hyprpicker
    discord
    imv
    spotify
  ];

  programs.thunar.enable = true;
  nixpkgs.overlays = [
    (final: prev: { qutebrowser = prev.qutebrowser.override { enableWideVine = true; }; })
  ];
}
