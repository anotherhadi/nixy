# Nixvim is a NixOS module that installs and configures Neovim
{ inputs, ... }: {
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    ./plugins/lsp.nix
    ./plugins/tree.nix
    ./plugins/telescope.nix
    ./plugins/cmp.nix
    ./plugins/ui.nix
    ./plugins/lualine.nix
    ./plugins/utils.nix
    ./plugins/dashboard.nix
    ./plugins/markdown.nix

    ./options.nix
    ./keymaps.nix
    ./autocmds.nix
  ];

  programs.nixvim.enable = true;
}
