{ config, ... }:
{
  programs.nvf.settings.vim = {
    filetree.neo-tree = {
      enable = true;
      setupOpts = {
        add_blank_line_at_top = true;
      };
    };
    telescope = {
      enable = true;
      mappings.findFiles = "<leader> ";
    };
    ui.noice.enable = true;
    binds.whichKey.enable = true;

    keymaps = [
      {
        key = "<leader>e";
        mode = "n";
        silent = true;
        action = ":Neotree toggle<CR>";
      }
    ];
    visuals = {
      nvim-web-devicons.enable = true;
    };
    theme = {
      enable = true;
      name = "base16";
      base16-colors = {
        base00 = config.lib.stylix.colors.base00;
        base01 = config.lib.stylix.colors.base01;
        base02 = config.lib.stylix.colors.base02;
        base03 = config.lib.stylix.colors.base03;
        base04 = config.lib.stylix.colors.base04;
        base05 = config.lib.stylix.colors.base05;
        base06 = config.lib.stylix.colors.base06;
        base07 = config.lib.stylix.colors.base07;
        base08 = config.lib.stylix.colors.base08;
        base09 = config.lib.stylix.colors.base09;
        base0A = config.lib.stylix.colors.base0A;
        base0B = config.lib.stylix.colors.base0B;
        base0C = config.lib.stylix.colors.base0C;
        base0D = config.lib.stylix.colors.base0D;
        base0E = config.lib.stylix.colors.base0E;
        base0F = config.lib.stylix.colors.base0F;
      };
    };
  };
}
