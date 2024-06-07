{ pkgs, config, ... }:
let
  variable = import ../../variables.nix;
  imports = [ ./hardware-configuration.nix ];
  # Weird variable name to avoid conflict with the `imports` variable...
  secondImports =
    if variable.enableNvidia then imports ++ [ ./nvidia.nix ] else imports;
  thirdImports = if variable.enablePrime then
    secondImports ++ [ ./prime.nix ]
  else
    secondImports;
in {
  imports = thirdImports;

  # Bootloader.
  boot = {
    loader.efi.canTouchEfiVariables = true;
    loader.systemd-boot = {
      enable = true;
      consoleMode = "auto";
    };
    tmp.cleanOnBoot = true;
  };

  networking.networkmanager.enable = true;

  networking.hostName = variable.hostName;

  time.timeZone = variable.timeZone;
  i18n.defaultLocale = variable.defaultLocale;
  i18n.extraLocaleSettings = {
    LC_ADDRESS = variable.extraLocale;
    LC_IDENTIFICATION = variable.extraLocale;
    LC_MEASUREMENT = variable.extraLocale;
    LC_MONETARY = variable.extraLocale;
    LC_NAME = variable.extraLocale;
    LC_NUMERIC = variable.extraLocale;
    LC_PAPER = variable.extraLocale;
    LC_TELEPHONE = variable.extraLocale;
    LC_TIME = variable.extraLocale;
  };

  users.users.${variable.username} = {
    isNormalUser = true;
    description = "${variable.username} account";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  services = {
    xserver = {
      xkb.layout = variable.keyboardLayout;
      xkb.variant = "";
    };
    blueman.enable = true;
    gnome.gnome-keyring.enable = true;
  };
  console.keyMap = variable.keyboardLayout;

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [ networkmanagerapplet ];

  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
    "nix-2.16.2"
  ]; # TODO: Remove this if not needed anymore

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
    gc = if variable.enableAutoGarbageCollector then {
      automatic = true;
      persistent = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    } else
      { };
  };

  system.autoUpgrade = if variable.enableAutoUpgrade then {
    enable = true;
    dates = "04:00";
    flake = "${config.users.users.${variable.username}.home}/.config/nixos";
    flags = [ "--update-input" "nixpkgs" "--commit-lock-file" ];
    allowReboot = false;
  } else
    { };

  nix.settings = {
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys =
      [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };

  services.dbus.enable = true;

  system.stateVersion = variable.stateVersion;
}
