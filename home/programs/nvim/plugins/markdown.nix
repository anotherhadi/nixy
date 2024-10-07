# The render-markdown.nvim plugin is a plugin that renders markdown files in a neovim in a more readable way.
{ pkgs, config, inputs, ... }: {
  programs.nixvim = {
    extraFiles = {
      "ftplugin/markdown.lua".text = ''
        vim.opt.tabstop = 2
        vim.opt.shiftwidth = 2
      '';
    };
    highlight = {
      RenderMarkdownBg.bg = "#${config.lib.stylix.colors.base00}";
      RenderMarkdownH1.fg = "#${config.lib.stylix.colors.base0D}";
      RenderMarkdownH2.fg = "#${config.lib.stylix.colors.base0D}";
      RenderMarkdownH3.fg = "#${config.lib.stylix.colors.base05}";
      RenderMarkdownH4.fg = "#${config.lib.stylix.colors.base05}";
      RenderMarkdownH5.fg = "#${config.lib.stylix.colors.base03}";
      RenderMarkdownH6.fg = "#${config.lib.stylix.colors.base03}";
    };
    extraPlugins = [
      (pkgs.vimUtils.buildVimPlugin {
        name = "markdown.nvim";
        src = inputs.plugin-markdown;
      })
    ];
    extraConfigLua =
      # lua
      ''
        require('render-markdown').setup({
          heading = {
            icons = { '# ', '󰲣 ', '󰲥 ', '󰲧 ', '󰲩 ', '󰲫 ' },
            backgrounds = {
                'RenderMarkdownBg',
            },
            foregrounds = {
                'RenderMarkdownH1',
                'RenderMarkdownH2',
                'RenderMarkdownH3',
                'RenderMarkdownH4',
                'RenderMarkdownH5',
                'RenderMarkdownH6',
            },
          },
          checkbox = {
            custom = {
              pending = { raw = '[-]', rendered = '󰥔 ', highlight = 'RenderMarkdownTodo' },
              important = { raw = '[!]', rendered = ' ', highlight = 'RenderMarkdownTodo' },
              cancle = { raw = '[/]', rendered = '󱋬 ', highlight = 'RenderMarkdownTodo' },
            },
          },
        })
      '';
  };
}
