# Neovim, configured with nvf (_*.nix are nvf modules)
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

  # Accents on top of the nvf colorscheme
  hlOverrides = {
    vim.luaConfigRC.hl-overrides = ''
      local function apply_hl()
        vim.api.nvim_set_hl(0, "MiniStarterHeader",   { fg = "${c.base0D}", bold = true })
        vim.api.nvim_set_hl(0, "SnacksPickerBorder",  { fg = "${c.base0D}" })
        vim.api.nvim_set_hl(0, "SnacksPickerTitle",   { fg = "${c.base0D}", bold = true })
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
      ({pkgs, ...}: {
        packages = [
          (mkNvim pkgs)
          # Opens files from file managers / xdg-open in a terminal
          (pkgs.makeDesktopItem {
            name = "nvim-ghostty";
            desktopName = "Neovim (Ghostty)";
            exec = ''${pkgs.ghostty}/bin/ghostty +new-window --title="Neovim Editor" -e nvim %F'';
            terminal = false;
            categories = ["Development" "TextEditor"];
            mimeTypes = editorTypes;
          })
        ];

        xdg.mime-apps = mime.defaultFor "nvim-ghostty.desktop" editorTypes;

        environment.sessionVariables = {
          EDITOR = "nvim";
          VISUAL = "nvim";
        };
      })
    ];
  };
}
