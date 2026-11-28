# NetBird: launcher action opening the settuings netbird page
_: {
  flake.modules.nixos.desktop.hjem.extraModules = [
    ({
      lib,
      pkgs,
      osConfig,
      scripts,
      ...
    }:
      lib.mkIf (osConfig.services.netbird.clients ? default) {
        launcher.netbird = {
          name = "NetBird";
          exec = "${scripts.term}/bin/term ${pkgs.nur.repos.anotherhadi.settuings}/bin/settuings --page netbird";
        };
      })
  ];
}
