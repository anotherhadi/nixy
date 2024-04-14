{
  programs.nixvim.plugins.toggleterm = {
    enable = true;
    settings = {
      open_mapping = "[[<c-t>]]";
      direction = "horizontal";
    };
  };
}
