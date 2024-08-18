{ pkgs, inputs, ... }: {

  fonts = {
    packages = with pkgs; [
      material-icons
      material-design-icons
      roboto
      work-sans
      comic-neue
      source-sans
      twemoji-color-font
      comfortaa
      inter
      lato
      lexend
      jost
      dejavu_fonts
      iosevka-bin
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      jetbrains-mono
      (nerdfonts.override { fonts = [ "FiraCode" "Meslo" ]; })
      inputs.apple-fonts.packages.${pkgs.system}.sf-pro-nerd
      inputs.apple-fonts.packages.${pkgs.system}.sf-mono-nerd
      openmoji-color
    ];

    enableDefaultPackages = false;

    fontconfig = {
      defaultFonts = {
        monospace = [ "FiraCode Nerd Font Mono" "Noto Color Emoji" ];
        sansSerif = [ "SFProDisplay Nerd Font" "Noto Color Emoji" ];
        serif = [ "SFProDisplay Nerd Font" "Noto Color Emoji" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };
}
