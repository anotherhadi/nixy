# The render-markdown.nvim plugin is a plugin that renders markdown files in a neovim in a more readable way.
{ pkgs, config, inputs, ... }:
let
  accent = "#${config.lib.stylix.colors.base0D}";
  muted = "#${config.lib.stylix.colors.base03}";
  background = "#${config.lib.stylix.colors.base00}";
in {

  programs.nixvim = {
    extraFiles = {
      "ftplugin/markdown.lua".text = ''
        vim.opt.tabstop = 2
        vim.opt.shiftwidth = 2
      '';
    };
    highlight = {
      RenderMarkdownBg.bg = background;
      RenderMarkdownH1.fg = accent;
      RenderMarkdownH2.fg = muted;
      RenderMarkdownH3.fg = muted;
      RenderMarkdownH4.fg = muted;
      RenderMarkdownH5.fg = muted;
      RenderMarkdownH6.fg = muted;
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
