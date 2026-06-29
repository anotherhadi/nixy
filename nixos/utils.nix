# Misc
{
  pkgs,
  config,
  ...
}: let
  hostname = config.var.hostname;
  keyboardLayout = config.var.keyboardLayout;
  configDir = config.var.configDirectory;
  timeZone = config.var.timeZone;
  defaultLocale = config.var.defaultLocale;
  extraLocale = config.var.extraLocale;
  autoUpgrade = config.var.autoUpgrade;
in {
  networking = {
    hostName = hostname;
    networkmanager.enable = true;
  };

  systemd.services.NetworkManager-wait-online.enable = false;
  system.autoUpgrade = {
    enable = autoUpgrade;
    dates = "04:00";
    flake = "${configDir}";
    flags = [
      "--update-input"
      "nixpkgs"
      "--commit-lock-file"
    ];
    allowReboot = false;
  };

  time = {
    timeZone = timeZone;
  };

  i18n = {
    defaultLocale = defaultLocale;
    extraLocaleSettings = {
      LC_ADDRESS = extraLocale;
      LC_IDENTIFICATION = extraLocale;
      LC_MEASUREMENT = extraLocale;
      LC_MONETARY = extraLocale;
      LC_NAME = extraLocale;
      LC_NUMERIC = extraLocale;
      LC_PAPER = extraLocale;
      LC_TELEPHONE = extraLocale;
      LC_TIME = extraLocale;
    };
  };

  services = {
    libinput.enable = true;
    xserver = {
      enable = true;
      xkb.layout = keyboardLayout;
    };
    gnome.gnome-keyring.enable = true;
    psd = {
      enable = true;
      resyncTimer = "10m";
    };
    dbus = {
      implementation = "broker";
      packages = with pkgs; [
        gcr
        gnome-settings-daemon
      ];
    };
    gvfs.enable = true;
    upower.enable = true;
    power-profiles-daemon.enable = true;
    udisks2.enable = true;
  };
  console.keyMap = keyboardLayout;

  environment = {
    variables = {
      PASSWORD_STORE_DIR = "$HOME/.local/share/password-store";
    };
    # enable zsh autocompletion for system packages (systemd, etc)
    pathsToLink = ["/share/zsh"];
    systemPackages = with pkgs; [
      fd
      bc
      gcc
      file
      git-ignore
      xdg-utils
      wget
      curl
      gnupg
      openssl
      vim
      go
      comma
      zip
      unzip
      optipng
      jpegoptim
      pfetch
      btop
      unrar
      p7zip
    ];
  };

  programs.dconf.enable = true;

  # Faster rebuilding
  documentation = {
    doc.enable = false;
    dev.enable = false;
    info.enable = false;
    nixos.enable = false;
  };

  xdg.portal = {
    xdgOpenUsePortal = true;
    config = {
      common.default = ["gtk"];
      hyprland.default = [
        "gtk"
        "hyprland"
      ];
    };

    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };

  security.rtkit.enable = true;
}
