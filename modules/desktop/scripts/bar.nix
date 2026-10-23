{
  flake.modules.nixos.desktop.hjem.extraModules = [
    ({pkgs, ...}: {
      scripts.bar-toggle = pkgs.writeShellScriptBin "bar-toggle" ''
        ${pkgs.sway}/bin/swaymsg bar mode toggle
      '';

      launcher.bar-toggle.name = "Toggle Bar";
    })
  ];
}
