# Keep awake: pauses swayidle or resumes it
{
  flake.modules.nixos.desktop.hjem.extraModules = [
    ({pkgs, ...}: {
      scripts.caffeine-toggle = pkgs.writeShellScriptBin "caffeine-toggle" ''
        if systemctl --user is-active --quiet swayidle; then
          systemctl --user stop swayidle
        else
          systemctl --user start swayidle
        fi
      '';

      launcher.caffeine-toggle.name = "Keep Awake";
    })
  ];
}
