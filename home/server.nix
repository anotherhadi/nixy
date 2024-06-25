{ pkgs, config, ... }: {

  imports = [
    ../hosts/server/variables.nix

    # Programs
    ./programs/btop
    ./programs/nvim
    ./programs/git
    ./programs/shell

    # Scripts
    ./scripts # All scripts
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
