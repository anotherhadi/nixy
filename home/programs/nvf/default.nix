{
  inputs,
  pkgs,
  config,
  ...
}: let
  c = config.lib.stylix.colors;
in {
  imports = [inputs.nvf.homeManagerModules.default];
  programs.nvf = {
    enable = true;
    settings = {
      vim.luaConfigRC.hl-overrides = ''
        local function apply_hl()
          vim.api.nvim_set_hl(0, "MiniStarterHeader",   { fg = "#${c.base0D}", bold = true })
          vim.api.nvim_set_hl(0, "SnacksPickerBorder",  { fg = "#${c.base0D}" })
          vim.api.nvim_set_hl(0, "SnacksPickerTitle",   { fg = "#${c.base0D}", bold = true })
        end
        apply_hl()
        vim.api.nvim_create_autocmd("ColorScheme", { pattern = "*", callback = apply_hl })
      '';
      imports = [
        ./options.nix
        ./languages.nix
        ./picker.nix
        ./snacks.nix
        ./keymaps.nix
        ./utils.nix
        ./mini.nix
      ];
    };
  };
}
