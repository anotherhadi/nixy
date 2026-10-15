# Fonts configuration for NixOS
{
  flake.modules.nixos.fonts = {pkgs, ...}: {
    fonts = {
      packages = with pkgs; [
        roboto
        work-sans
        comic-neue
        source-sans
        comfortaa
        inter
        lato
        lexend
        jost
        dejavu_fonts
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-color-emoji
        nerd-fonts.fira-code
        nerd-fonts.meslo-lg
        openmoji-color
        twemoji-color-font
      ];

      enableDefaultPackages = false;
    };
  };
}
