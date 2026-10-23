# Myx is a lean terminal Spotify player written in Rust, with album-art-reactive
# theming, a live visualizer and synced lyrics.
{
  aspects,
  config,
  ...
}: let
  inherit (config.flake.lib) mkSandbox;
in {
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

    systemd.user.tmpfiles.rules = [
      "d %h/.config/myx 0700 - - -"
      "d %h/.cache/myx 0700 - - -"
    ];

    hjem.extraModules = [
      ({pkgs, ...}: let
        # Sandboxed: network (Spotify), audio, MPRIS, only its config and cache
        myx = (mkSandbox pkgs).wrap {
          package = pkgs.unstable.myx;
          config = {sloth, ...}: {
            dbus = {
              enable = true;
              policies."org.mpris.MediaPlayer2.myx" = "own"; # Media keys (souvlaki panics without a bus)
            };
            bubblewrap = {
              network = true;
              bind.rw = map (d: sloth.concat' sloth.homeDir "/${d}") [".config/myx" ".cache/myx"];
              bind.ro = ["/run/secrets/myx-config"]; # ~/.config/myx/config.toml is a symlink to it
              sockets = {
                pipewire = true;
                pulse = true;
              };
            };
          };
        };
      in {
        packages = [
          myx
          (pkgs.makeDesktopItem {
            name = "myx";
            desktopName = "Spotify";
            exec = "${pkgs.kitty}/bin/kitty -o window_padding_width=0 ${myx}/bin/myx";
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
