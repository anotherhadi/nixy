{
  inputs,
  nixpkgs,
  ...
}:
nixpkgs.lib.nixosSystem {
  modules = [
    {
      nixpkgs.overlays = [
        (final: prev: {
          # FIXME: Workaround: Mesa crash with AMD GPU + Wayland + Qt 6.11.0
          qutebrowser = prev.symlinkJoin {
            name = "qutebrowser";
            paths = [prev.qutebrowser];
            buildInputs = [prev.makeWrapper];
            postBuild = ''
              wrapProgram $out/bin/qutebrowser \
                --set LIBGL_ALWAYS_SOFTWARE 1
            '';
          };
        })
      ];
      _module.args = {inherit inputs;};
    }
    inputs.nixos-hardware.nixosModules.omen-16-n0005ne
    inputs.home-manager.nixosModules.home-manager
    inputs.stylix.nixosModules.stylix
    inputs.nix-index-database.nixosModules.default
    ./configuration.nix
  ];
}
