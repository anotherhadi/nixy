{ pkgs, config, ... }:
let variable = import ../../variables.nix;
in {
  imports = [ ./hardware-configuration.nix ./openssh.nix ];

  boot = {
    loader.efi.canTouchEfiVariables = true;
    loader.systemd-boot = {
      enable = true;
      consoleMode = "auto";
    };
    tmp.cleanOnBoot = true;
  };

  networking.hostName = variable.server.hostName;

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
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBVDICWA/+W3Qqgoxw6pIwPAjRmTYKWnsEPD/cRTNgzP hadi@heaven"
    ];
  };

  console.keyMap = variable.keyboardLayout;

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  security.rtkit.enable = true;

  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
    };
    gc = if variable.server.enableAutoGarbageCollector then {
      automatic = true;
      persistent = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    } else
      { };
  };

  system.autoUpgrade = if variable.server.enableAutoUpgrade then {
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

  system.stateVersion = variable.server.stateVersion;
}
