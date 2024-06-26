{ pkgs, config, ... }: {

  imports = [
    ./variables.nix

    # Programs
    ../../home/programs/btop
    ../../home/programs/nvim
    ../../home/programs/git
    ../../home/programs/shell

    # Scripts
    ../../home/scripts # All scripts
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
