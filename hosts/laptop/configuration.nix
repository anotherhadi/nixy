{ pkgs, config, ... }: {
  imports = [
    ./hardware-configuration.nix
    ../shared/fonts.nix
    ../shared/nvidia.nix
    ../shared/prime.nix
    ../shared/tuigreet.nix
    ./variables.nix
  ];

  # Bootloader.
  boot = {
    loader.efi.canTouchEfiVariables = true;
    loader.systemd-boot = {
      enable = true;
      consoleMode = "auto";
    };
    tmp.cleanOnBoot = true;
    kernelPackages =
      pkgs.linuxPackages_latest; # _zen, _hardened, _rt, _rt_latest, etc.
  };

  # Networking
  networking.networkmanager.enable = true;
  networking.hostName = config.var.hostname;

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
    extraGroups = [ "networkmanager" "wheel" ];
  };

  services = {
    xserver = {
      enable = true;
      xkb.layout = config.var.keyboardLayout;
      xkb.variant = "";
    };
    blueman.enable = true;
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
  environment.systemPackages = with pkgs; [ networkmanagerapplet ];
  nixpkgs.config.permittedInsecurePackages = [ "electron-25.9.0" ];

  system.autoUpgrade = if config.var.autoUpgrade then {
    enable = true;
    dates = "04:00";
    flake = "${config.users.users.${config.var.username}.home}/.config/nixos";
    flags = [ "--update-input" "nixpkgs" "--commit-lock-file" ];
    allowReboot = false;
  } else
    { };

  xdg.portal = {
    enable = true;
    configPackages = with pkgs; [ xdg-desktop-portal-gtk ];
  };

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
