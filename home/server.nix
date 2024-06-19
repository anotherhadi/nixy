{ pkgs, config, ... }: {

  imports = [
    ../hosts/server/variables.nix

    # Programs
    ./programs/btop
    ./programs/nvim

    # Scripts
    ./scripts # All scripts

    # System
    ./system/git
    ./system/shell
    # ./system/sops/server.nix # You should probably remove this line
  ];

  home = {
    inherit (config.var) username;
    inherit (config.var) homeDirectory;

    packages = with pkgs; [
      # Dev
      go
      cargo
      nodejs
      python3
      jq

      # Utils
      fd
      bc
      gcc
      zip
      unzip
      wget
      curl
      glow
      wireguard-tools
      pfetch
    ];

    stateVersion = "24.05";
  };

  programs.home-manager.enable = true;

}
