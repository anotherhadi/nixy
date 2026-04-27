{
  inputs,
  pkgs,
  ...
}: {
  imports = [inputs.nvf.homeManagerModules.default];

  # Packages needed by snacks image preview
  home.packages = with pkgs; [
    imagemagick
    tree-sitter
    ghostscript
    tectonic
    mermaid-cli
  ];

  programs.nvf = {
    enable = true;
    settings = {
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
