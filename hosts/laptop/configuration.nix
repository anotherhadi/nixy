{ pkgs, config, ... }: {
  imports = [
    ./hardware-configuration.nix
    ../modules/fonts.nix
    ../modules/nvidia.nix
    # ../modules/prime.nix
    ../modules/tuigreet.nix
    ../modules/timezone.nix
    ../modules/usb.nix
    ../modules/systemd-boot.nix
    ../modules/users.nix
    ../modules/audio.nix
    ../modules/bluetooth.nix
    ./variables.nix
  ];

  networking.networkmanager.enable = true;
  networking.hostName = config.var.hostname;
  systemd.services.NetworkManager-wait-online.enable = false;

  services = {
    tailscale.enable = config.var.tailscale;
    xserver = {
      enable = true;
      xkb.layout = config.var.keyboardLayout;
      xkb.variant = "";
    };
    blueman.enable = true;
    gnome.gnome-keyring.enable = true;
  };
  console.keyMap = config.var.keyboardLayout;

  programs.zsh = {
    enable = true;
    loginShellInit = ''
      dbus-update-activation-environment --systemd DISPLAY
    '';
  };
  users.defaultUserShell = pkgs.zsh;

  environment.variables = {
    XDG_DATA_HOME = "$HOME/.local/share";
    PASSWORD_STORE_DIR = "$HOME/.local/share/password-store";
    EDITOR = "nvim";
  };

  nix = {
    extraOptions = ''
      warn-dirty = false
    '';
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
    };
    gc = {
      automatic = config.var.autoGarbageCollector;
      persistent = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    networkmanagerapplet
    fd
    bc
    gcc
    git-ignore
    xdg-utils
    wget
    curl
  ];

  # nixpkgs.config.permittedInsecurePackages =
  #   [ "electron-25.9.0" ]; # TODO: test to remove

  system.autoUpgrade = {
    enable = config.var.autoUpgrade;
    dates = "04:00";
    flake = "${config.var.configDirectory}";
    flags = [ "--update-input" "nixpkgs" "--commit-lock-file" ];
    allowReboot = false;
  };

  # xdg.portal = { # TODO: test to remove
  #   enable = true;
  #   configPackages = with pkgs; [ xdg-desktop-portal-gtk ];
  # };

  services.libinput.enable = true;
  programs.dconf.enable = true;

  # Faster rebuilding
  documentation = {
    enable = true;
    doc.enable = false;
    man.enable = true;
    dev.enable = false;
  };

  services.dbus.enable = true;

  # Don't touch this
  system.stateVersion = "24.05";
}
