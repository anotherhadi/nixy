{
  lib,
  pkgs,
  ...
}: {
  vim = {
    diagnostics = {
      enable = true;
      config = {
        signs = {
          text = {
            "vim.diagnostic.severity.Error" = " ";
            "vim.diagnostic.severity.Warn" = " ";
            "vim.diagnostic.severity.Hint" = " ";
            "vim.diagnostic.severity.Info" = " ";
          };
        };
        underline = true;
        update_in_insert = false;
        virtual_text = true;
      };
      nvim-lint = {
        enable = true;
      };
    };
    treesitter = {
      enable = true;
      autotagHtml = true;
      context.enable = false;
      highlight.enable = true;
      textobjects.enable = true;
      grammars = [
        pkgs.vimPlugins.nvim-treesitter.grammarPlugins.http
        pkgs.vimPlugins.nvim-treesitter.grammarPlugins.tsx
      ];
    };
    lsp = {
      enable = true;
      presets = {
        tailwindcss-language-server = {
          enable = true;
        };
        vtsls = {
          enable = true;
        };
      };
      trouble.enable = true;
      lspSignature.enable = true;
      lspconfig.enable = true;
      formatOnSave = true; # through conform, toggled by vim.g.formatsave
      mappings.format = null;
      inlayHints.enable = true;
      servers.nil.settings.nix.autoArchive = true;
      otter-nvim = {
        enable = true;
        setupOpts = {
          buffers.set_filetype = true;
          lsp = {
            diagnostic_update_event = [
              "BufWritePost"
              "InsertLeave"
            ];
          };
        };
      };
      lspkind.enable = true;
      lspsaga = {
        enable = true;
        setupOpts = {
          ui = {
            code_action = "";
          };
          lightbulb = {
            sign = false;
            virtual_text = true;
          };
          symbol_in_winbar.enable = false;
        };
      };
    };
    languages = {
      enableExtraDiagnostics = true;
      enableFormat = true;
      enableTreesitter = true;

      python = {
        enable = true;
        lsp = {
          enable = true;
          servers = ["pyright"];
        };
      };
      astro.enable = true;
      go.enable = true;
      markdown = {
        enable = true;
        format.type = ["deno"];
        extensions.render-markdown-nvim = {
          enable = true;
          # render in every mode, anti_conceal (on by default) keeps the cursor line raw
          setupOpts.render_modes = true;
        };
        extraDiagnostics.enable = false;
      };
      typescript = {
        enable = true;
        # vtsls preset used instead: ts_ls here misses .tsx filetypes
        lsp.servers = [];
      };
      css.enable = true;
      svelte.enable = true;
      html.enable = true;
      bash.enable = true;
      nix.enable = true;
      lua.enable = true;
    };
    formatter = {
      conform-nvim = {
        enable = true;
        setupOpts.format_after_save = null; # format_on_save already formats, don't run twice
        # Prefer the project's pinned prettier (node_modules/.bin), so nvim, npm run format
        # and CI format identically. nvf hardcodes the nixpkgs one, hence mkForce.
        setupOpts.formatters.prettier.command = lib.mkForce (lib.generators.mkLuaInline ''
          require("conform.util").find_executable({ "node_modules/.bin/prettier" }, "${lib.getExe pkgs.prettier}")
        '');
        # deno defaults to proseWrap=always (hard wrap at 80), which strands long links on
        # their own line; keep the line breaks as written.
        setupOpts.formatters.deno.append_args = ["--prose-wrap" "preserve"];
      };
    };
  };
}
