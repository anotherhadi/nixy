# Home server
{
  aspects,
  inputs,
  ...
}: {
  flake.nixosConfigurations.jack = inputs.nixpkgs.lib.nixosSystem {
    modules = with aspects; [
      common
      # Host values (modules/hosts/common.nix)
      {
        networking.hostName = "jack";
        nixy = {
          username = "hadi";
          git = {
            name = "Hadi";
            email = "112569860+anotherhadi@users.noreply.github.com";
          };
          server = {
            domain = "hadi.icu";
            tunnelId = "a1dfa315-7fc3-4a65-8c02-8387932c35c3";
            networkInterface = "enp3s0";
          };
        };
      }

      inputs.sops-nix.nixosModules.sops

      # System
      theme
      hjem
      nix
      systemd-boot
      users
      networking
      locale
      cli-base
      amd-graphics
      kernel-hardening

      # Services
      homelab # see modules/bundles.nix

      # Programs
      tui # shell, git, nvim, cybersecurity... (see modules/bundles.nix)
      git-signing # CHANGEME: Change the key or remove this line

      # Host-specific (plain NixOS modules, "_" keeps import-tree away)
      ./_configuration.nix
    ];
  };
}
