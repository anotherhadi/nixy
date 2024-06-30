{ pkgs, config, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./variables.nix
    ../modules/usb.nix

    # internal
    ./modules/internal/security.nix
    ./modules/internal/openssh.nix
    ./modules/internal/adguard.nix
    ./modules/internal/cockpit.nix
    # ./modules/internal/unifi.nix # FIXME: unifi5 is deprecated

    # exposed
    ./modules/exposed/ntfy-sh.nix
    ./modules/exposed/tailscale.nix
    ./modules/exposed/kuma.nix
    ./modules/exposed/cloudflare-dyndns.nix
    ./modules/exposed/nginx.nix
    ./modules/exposed/nextcloud.nix
    ./modules/exposed/vaultwarden.nix
    # ./modules/exposed/bitcoin-git.nix # FIXME: bitcoin-git is deprecated
    ./modules/www

    # jackflix
    ./modules/jackflix

    ./secrets
  ];

  # Bootloader.
  boot = {
    loader.grub.enable = true;
    loader.grub.device = "/dev/sda";
    loader.grub.useOSProber = true;
    tmp.cleanOnBoot = true;
    kernelPackages =
      pkgs.linuxPackages_latest; # _zen, _hardened, _rt, _rt_latest, etc.
  };

  virtualisation.docker.enable = true;

  # Networking
  networking = { hostName = config.var.hostname; };

  # Timezone and locale
  time.timeZone = config.var.timeZone;
  i18n.defaultLocale = config.var.defaultLocale;
  i18n.extraLocaleSettings = {
    LC_ADDRESS = config.var.extraLocale;
    LC_IDENTIFICATION = config.var.extraLocale;
    LC_MEASUREMENT = config.var.extraLocale;
    LC_MONETARY = config.var.extraLocale;
    LC_NAME = config.var.extraLocale;
    LC_NUMERIC = config.var.extraLocale;
    LC_PAPER = config.var.extraLocale;
    LC_TELEPHONE = config.var.extraLocale;
    LC_TIME = config.var.extraLocale;
  };

  # Users
  users.users.${config.var.username} = {
    isNormalUser = true;
    description = "${config.var.username} account";
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [ config.var.sshPublicKey ];
  };

  services = {
    xserver = {
      enable = true;
      xkb.layout = config.var.keyboardLayout;
      xkb.variant = "";
    };
    gnome.gnome-keyring.enable = true;
  };
  console.keyMap = config.var.keyboardLayout;

  # Shell
  programs.zsh = {
    enable = true;
    loginShellInit = ''
      dbus-update-activation-environment --systemd DISPLAY
    '';
  };
  users.defaultUserShell = pkgs.zsh;

  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
    };
    gc = if config.var.autoGarbageCollector then {
      automatic = true;
      persistent = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    } else
      { };
  };

  nixpkgs.config.allowUnfree = true;

  system.autoUpgrade = if config.var.autoUpgrade then {
    enable = true;
    dates = "04:00";
    flake = "${config.var.configDirectory}";
    flags = [ "--update-input" "nixpkgs" "--commit-lock-file" ];
    allowReboot = false;
  } else
    { };

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
