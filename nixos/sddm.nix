# SDDM is a display manager for X11 and Wayland
{
  pkgs,
  inputs,
  config,
  ...
}: let
  foreground = config.theme.textColorOnWallpaper;
  sddm-astronaut = pkgs.sddm-astronaut.override {
    embeddedTheme = "pixel_sakura";
    themeConfig = {
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
      Background =
        if "sakura_pixelart_light_static.png" == config.stylix.image
        then
          pkgs.fetchurl {
            url = "https://raw.githubusercontent.com/anotherhadi/awesome-wallpapers/refs/heads/main/app/static/wallpapers/sakura_pixelart_light_animated.gif";
            sha256 = "sha256-qySDskjmFYt+ncslpbz0BfXiWm4hmFf5GPWF2NlTVB8=";
          }
        else if "cat-watching-the-star_pixelart_purple_static.png" == config.stylix.image
        then
          pkgs.fetchurl {
            url = "https://raw.githubusercontent.com/anotherhadi/awesome-wallpapers/refs/heads/main/app/static/wallpapers/cat-watching-the-star_pixelart_purple_animated.gif";
            sha256 = "";
          }
        else "${toString config.stylix.image}";
    };
  };
in {
  services.displayManager = {
    sddm = {
      package = pkgs.kdePackages.sddm;
      extraPackages = [sddm-astronaut];
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

  environment.systemPackages = [sddm-astronaut];
}
