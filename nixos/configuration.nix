{ pkgs, config, ... }: {
  imports = [ ./hardware-configuration.nix ./nvidia.nix ];

  # Bootloader.
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot = {
    enable = true;
    consoleMode = "auto";
  };

  networking.networkmanager.enable = true;

  ##############

  # CHANGEME
  networking.hostName = "nixy";
  time.timeZone = "Europe/Paris";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };

  users.users.hadi = { # CHANGEME
    isNormalUser = true;
    description = "Hadi account";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # Auto Update & Clean
  system.autoUpgrade = {
    enable = true;
    dates = "04:00";
    flake = "${config.users.users.hadi.home}/.config/nixos"; # CHANGEME
    flags = [ "--update-input" "nixpkgs" "--commit-lock-file" ];
    allowReboot = true;
  };

  ##############

  services = {
    xserver = {
      xkb.layout = "fr";
      xkb.variant = "";
    };
    blueman.enable = true;
    gnome.gnome-keyring.enable = true;
  };
  console.keyMap = "fr";

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [ networkmanagerapplet ];

  nixpkgs.config.permittedInsecurePackages = [ "electron-25.9.0" "nix-2.16.2" ];

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # Set environment variables
  environment.variables = {
    XDG_DATA_HOME = "$HOME/.local/share";
    PASSWORD_STORE_DIR = "$HOME/.local/share/password-store";
    MOZ_ENABLE_WAYLAND = "1";
    EDITOR = "nvim";
    ANKI_WAYLAND = "1";
    DISABLE_QT5_COMPAT = "0";
    NIXOS_OZONE_WL = "1";
  };

  # Sound
  sound = { enable = true; };

  security.rtkit.enable = true;
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };

  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
    };
    gc = {
      automatic = true;
      persistent = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  services.dbus.enable = true;

  system.stateVersion = "23.11";
}
