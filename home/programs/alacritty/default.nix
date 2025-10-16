# Alacritty is a fast, cross-platform, OpenGL terminal emulator.
{
  programs.alacritty = {
    enable = true;
    settings = {
      window.padding = {
        x = 10;
        y = 10;
      };
    };
  };
}
