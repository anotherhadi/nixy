# Proton tools: andcli (2FA TUI reading a Proton Authenticator export) and Proton VPN
# TODO: proton-pass-agent ?
{aspects, ...}: {
  flake.modules.nixos.proton = {
    imports = [aspects.hjem];

    hjem.extraModules = [
      ({
        config,
        lib,
        pkgs,
        options,
        ...
      }: let
        andcli = "${pkgs.unstable.andcli}/bin/andcli";
      in {
        config = lib.mkMerge [
          {
            packages = [
              pkgs.unstable.andcli # 2FA TUI for your shell
              (pkgs.makeDesktopItem {
                name = "andcli";
                desktopName = "andcli";
                exec = "${pkgs.ghostty}/bin/ghostty +new-window -e ${andcli} ${config.directory}/.cache/protonauth.json.txt --type protonauth";
                comment = "2FA TUI for your shell";
                categories = ["Utility" "Security" "ConsoleOnly"];
                terminal = false;
                keywords = ["2fa" "otp" "totp" "authenticator" "security"];
              })

              # TODO: config + desktop file
              pkgs.nur.repos.anotherhadi.proton-vpn-tui
              pkgs.proton-vpn-cli
            ];

            persist.directories = [".config/andcli"];
          }

          (lib.optionalAttrs (options ? zsh) {
            zsh.shellAliases.andcli = "${andcli} ~/.cache/protonauth.json.txt --type protonauth";
          })
        ];
      })
    ];
  };
}
