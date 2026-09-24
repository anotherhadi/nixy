{
  pkgs,
  lib,
  config,
  ...
}: let
  # Launched with a file (opened via xdg-open/mimeapps): play just that
  # track. Launched bare (app menu, "Music Player" icon): open the normal
  # library browser. `kew play` with no path errors out with "Music not
  # found", so this can't just always prepend "play".
  kewLauncher = pkgs.writeShellScript "kew-launcher" ''
    if [ -n "$1" ]; then
      exec ${pkgs.kew}/bin/kew play "$1"
    else
      exec ${pkgs.kew}/bin/kew
    fi
  '';
in {
  home.packages = with pkgs; [
    kew
  ];

  home.persistence."/persist" = lib.mkIf (config.var.impermanenceEnabled or false) {
    directories = [
      ".config/kew"
    ];
  };

  xdg.desktopEntries.kew = {
    name = "Music Player";
    exec = "${pkgs.ghostty}/bin/ghostty --window-padding-x=0 --window-padding-y=0 -e ${kewLauncher} %f";
    comment = "Play music from the terminal";
    categories = ["Audio" "Music"];
    terminal = false;
    mimeType = [
      "audio/aac"
      "audio/mpeg"
      "audio/ogg"
      "audio/opus"
      "audio/vnd.wave"
      "audio/webm"
      "audio/x-matroska"
      "audio/flac"
      "audio/mp4"
    ];
    settings.Keywords = "lofi;player;music;";
  };
}
