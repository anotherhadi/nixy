{ config, ... }:
let
  accent = "#${config.lib.stylix.colors.base0D}";
  muted = "#${config.lib.stylix.colors.base03}";
  foreground = "#${config.lib.stylix.colors.base05}";
  configDir = config.var.configDirectory;
in {

  programs.nixvim.highlight = {
    AlphaHeaderColor.fg = accent;
    AlphaTextColor.fg = foreground;
    AlphaShortcutColor.fg = muted;
  };

  programs.nixvim.plugins.alpha = {
    enable = true;
    layout = [
      {
        type = "padding";
        val = 4;
      }
      {
        type = "text";
        opts = {
          position = "center";
          hl = "AlphaHeaderColor";
        };
        val = [
          "                                                                     "
          "       ████ ██████           █████      ██                     "
          "      ███████████             █████                             "
          "      █████████ ███████████████████ ███   ███████████   "
          "     █████████  ███    █████████████ █████ ██████████████   "
          "    █████████ ██████████ █████████ █████ █████ ████ █████   "
          "  ███████████ ███    ███ █████████ █████ █████ ████ █████  "
          " ██████  █████████████████████ ████ █████ █████ ████ ██████ "
          "                                                                       "
        ];
      }
      {
        type = "padding";
        val = 4;
      }
      {
        type = "group";

        val = [
          {
            type = "button";
            val = "󰭎  Find file";
            on_press.__raw = "function() vim.cmd[[Telescope find_files]] end";
            opts = {
              shortcut = "nf";
              position = "center";
              cursor = 3;
              width = 50;
              align_shortcut = "right";
              hl_shortcut = "AlphaShortcutColor";
              hl = "AlphaTextColor";
            };
          }
          {
            type = "button";
            val = "  New file";
            on_press.__raw = "function() vim.cmd[[ene]] end";
            opts = {
              shortcut = "nn";
              position = "center";
              cursor = 3;
              width = 50;
              align_shortcut = "right";
              hl_shortcut = "AlphaShortcutColor";
              hl = "AlphaTextColor";
            };
          }
          {
            type = "button";
            val = "  NixOs Config";
            on_press.__raw = "function() vim.cmd[[Neotree ${configDir}]] end";
            opts = {
              shortcut = "nc";
              position = "center";
              cursor = 3;
              width = 50;
              align_shortcut = "right";
              hl_shortcut = "AlphaShortcutColor";
              hl = "AlphaTextColor";
            };
          }
          {
            type = "button";
            val = "  Keybindings";
            on_press.__raw =
              "function() vim.cmd[[e ${configDir}/docs/KEYBINDINGS.md]] end";
            opts = {
              shortcut = "nc";
              position = "center";
              cursor = 3;
              width = 50;
              align_shortcut = "right";
              hl_shortcut = "AlphaShortcutColor";
              hl = "AlphaTextColor";
            };
          }
          {
            type = "button";
            val = "  Recently used";
            on_press.__raw = "function() vim.cmd[[Telescope oldfiles]] end";
            opts = {
              shortcut = "no";
              position = "center";
              cursor = 3;
              width = 50;
              align_shortcut = "right";
              hl_shortcut = "AlphaShortcutColor";
              hl = "AlphaTextColor";
            };
          }
          {
            type = "button";
            val = "󰱽  Find text";
            on_press.__raw = "function() vim.cmd[[Telescope live_grep]] end";
            opts = {
              shortcut = "nt";
              position = "center";
              cursor = 3;
              width = 50;
              align_shortcut = "right";
              hl_shortcut = "AlphaShortcutColor";
              hl = "AlphaTextColor";
            };
          }
          {
            type = "button";
            val = "󰩈  Quit Neovim";
            on_press.__raw = "function() vim.cmd[[qa]] end";
            opts = {
              shortcut = "nq";
              position = "center";
              cursor = 3;
              width = 50;
              align_shortcut = "right";
              hl_shortcut = "AlphaShortcutColor";
              hl = "AlphaTextColor";
            };
          }
        ];

      }
    ];
  };

}
