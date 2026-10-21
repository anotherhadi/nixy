# Myx is a lean terminal Spotify player written in Rust, with album-art-reactive
# theming, a live visualizer and synced lyrics.
{aspects, ...}: {
  flake.modules.nixos.myx = {
    config,
    lib,
    ...
  }: let
    username = config.nixy.username;
  in {
    imports = [
      aspects.hjem
      aspects.secrets
    ];

    # Spotify credentials, on hosts whose sops file has them
    sops.secrets.myx-config = lib.mkIf (builtins.elem "myx-config" config.nixy.secrets.available) {
      owner = username;
      mode = "0600";
      path = "${config.users.users.${username}.home}/.config/myx/config.toml";
    };

    hjem.extraModules = [
      ({pkgs, ...}: {
        packages = [
          pkgs.unstable.myx
          (pkgs.makeDesktopItem {
            name = "myx";
            desktopName = "Spotify";
            exec = "${pkgs.ghostty}/bin/ghostty --window-padding-x=0 --window-padding-y=0 -e ${pkgs.unstable.myx}/bin/myx";
            icon = "spotify";
            comment = "Control Spotify from the terminal";
            categories = ["Audio" "Music"];
            terminal = false;
            keywords = ["spotify" "myx" "music"];
          })
        ];

        persist.directories = [".config/myx"];
      })
    ];
  };
}
