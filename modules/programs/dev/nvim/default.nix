# Neovim, configured with nvf
# Also exposed standalone: nix run .#nvim
{
  aspects,
  inputs,
  config,
  ...
}: let
  c = config.theme.withHashtag;
  inherit (config.flake.lib) mime;
  editorTypes = mime.types.text ++ mime.types.code;

  # Catppuccin Mocha, with the darker backgrounds of the global palette.
  # Loaded by hand: nvf's catppuccin setup is hardcoded (no color_overrides, no snacks/mini integrations)
  theme = {pkgs, ...}: {
    vim.extraPlugins.catppuccin = {
      package = pkgs.vimPlugins.catppuccin-nvim;
      setup = ''
        require("catppuccin").setup({
          flavour = "mocha",
          term_colors = true,
          color_overrides = {
            mocha = {
              base = "${c.base00}",
              mantle = "${c.base10}",
              crust = "${c.base11}",
            },
          },
          integrations = {
            blink_cmp = true,
            cmp = true,
            gitsigns = true,
            lsp_trouble = true,
            lsp_saga = true,
            markdown = true,
            render_markdown = true,
            mini = { enabled = true },
            snacks = { enabled = true },
            noice = true,
            notify = true,
            rainbow_delimiters = true,
            treesitter = true,
            native_lsp = { enabled = true },
          },
        })
        vim.cmd.colorscheme("catppuccin")
      '';
    };
  };

  # Accents on top of the colorscheme
  hlOverrides = {
    vim.luaConfigRC.hl-overrides = ''
      local function apply_hl()
        vim.api.nvim_set_hl(0, "MiniStarterHeader",   { fg = "${c.base0D}", bold = true })
        vim.api.nvim_set_hl(0, "SnacksPickerBorder",  { fg = "${c.base0D}" })
        vim.api.nvim_set_hl(0, "SnacksPickerTitle",   { fg = "${c.base0D}", bold = true })
        vim.api.nvim_set_hl(0, "WinSeparator",        { fg = "${c.base02}" })
        vim.api.nvim_set_hl(0, "VertSplit",           { fg = "${c.base02}" })
      end
      apply_hl()
      vim.api.nvim_create_autocmd("ColorScheme", { pattern = "*", callback = apply_hl })
    '';
  };

  mkNvim = pkgs:
    (inputs.nvf.lib.neovimConfiguration {
      inherit pkgs;
      modules = [
        ./_options.nix
        ./_languages.nix
        ./_picker.nix
        ./_snacks.nix
        ./_keymaps.nix
        ./_utils.nix
        ./_mini.nix
        theme
        hlOverrides
      ];
    }).neovim;
in {
  perSystem = {
    pkgs,
    self',
    ...
  }: {
    packages.nvim = mkNvim pkgs;
    apps.nvim = {
      type = "app";
      program = "${self'.packages.nvim}/bin/nvim";
    };
  };

  flake.modules.nixos.nvim = {
    imports = [aspects.hjem];

    hjem.extraModules = [
      ({
        pkgs,
        scripts,
        ...
      }: {
        packages = [
          (mkNvim pkgs)
          # Opens files from file managers / xdg-open in a terminal
          (pkgs.makeDesktopItem {
            name = "nvim-term";
            desktopName = "Neovim";
            exec = ''${scripts.term}/bin/term --title="Neovim Editor" nvim %F'';
            terminal = false;
            categories = ["Development" "TextEditor"];
            mimeTypes = editorTypes;
          })
        ];

        xdg.mime-apps = mime.defaultFor "nvim-term.desktop" editorTypes;

        environment.sessionVariables = {
          EDITOR = "nvim";
          VISUAL = "nvim";
        };
      })
    ];
  };
}
