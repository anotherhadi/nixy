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
              keymap = [
                "n"
                "nf"
                ":Telescope find_files <CR>"
                {
                  noremap = true;
                  silent = true;
                  nowait = true;
                }
              ];
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
              keymap = [
                "n"
                "nn"
                ":ene <CR>"
                {
                  noremap = true;
                  silent = true;
                  nowait = true;
                }
              ];
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
              keymap = [
                "n"
                "nc"
                ":Neotree ${configDir} <CR>"
                {
                  noremap = true;
                  silent = true;
                  nowait = true;
                }
              ];
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
              shortcut = "nk";
              keymap = [
                "n"
                "nk"
                ":e ${configDir}/docs/KEYBINDINGS-HYPRLAND.md <CR>"
                {
                  noremap = true;
                  silent = true;
                  nowait = true;
                }
              ];
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
              keymap = [
                "n"
                "no"
                ":Telescope oldfiles <CR>"
                {
                  noremap = true;
                  silent = true;
                  nowait = true;
                }
              ];
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
              shortcut = "ng";
              keymap = [
                "n"
                "ng"
                ":Telescope live_grep <CR>"
                {
                  noremap = true;
                  silent = true;
                  nowait = true;
                }
              ];
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
              keymap = [
                "n"
                "nq"
                ":qa <CR>"
                {
                  noremap = true;
                  silent = true;
                  nowait = true;
                }
              ];
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
