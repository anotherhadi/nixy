# Zen is a minimalistic web browser.
{ pkgs, inputs, ... }: {
  home.packages = with pkgs;
    [ inputs.zen-browser.packages."${system}".default ];
}
