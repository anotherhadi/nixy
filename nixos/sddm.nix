{ pkgs, inputs, config, lib, ... }:
let
  foreground = config.theme.textColorOnWallpaper;
  sddm-astronaut = pkgs.sddm-astronaut.override {
    embeddedTheme = "pixel_sakura";
    themeConfig = if lib.hasSuffix "sakura_static.png" config.stylix.image then
      { }
    else {
      Background = "${toString config.stylix.image}";
      HeaderTextColor = "#${foreground}";
      DateTextColor = "#${foreground}";
      TimeTextColor = "#${foreground}";
      LoginFieldTextColor = "#${foreground}";
      PasswordFieldTextColor = "#${foreground}";
      UserIconColor = "#${foreground}";
      PasswordIconColor = "#${foreground}";
      WarningColor = "#${foreground}";
      LoginButtonBackgroundColor = "#${foreground}";
      SystemButtonsIconsColor = "#${foreground}";
      SessionButtonTextColor = "#${foreground}";
      VirtualKeyboardButtonTextColor = "#${foreground}";
      DropdownBackgroundColor = "#${foreground}";
      HighlightBackgroundColor = "#${foreground}";
    };
  };
in {
  services.displayManager = {
    sddm = {
      package = pkgs.kdePackages.sddm;
      extraPackages = [ sddm-astronaut ];
      enable = true;
      wayland.enable = true;
      theme = "sddm-astronaut-theme";
      settings = {
        Wayland.SessionDir = "${
            inputs.hyprland.packages."${pkgs.system}".hyprland
          }/share/wayland-sessions";
      };
    };
  };

  services.getty = {
    autologinUser = null;
    helpLine = lib.mkForce "";
  };
  systemd.services."getty@tty1".enable = false;

  environment.systemPackages = [ sddm-astronaut ];

  # To prevent getting stuck at shutdown
  systemd.extraConfig = "DefaultTimeoutStopSec=10s";
}
