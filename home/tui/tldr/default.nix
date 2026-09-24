# TLDR provides simplified, example-based help pages for shell commands
{
  pkgs,
  inputs,
  ...
}: let
  tealdeerCache = pkgs.runCommand "tealdeer-tldr-cache" {} ''
    mkdir -p $out/tldr-pages
    for d in ${inputs.tldr-pages-src}/pages ${inputs.tldr-pages-src}/pages.*; do
      [ -d "$d" ] || continue
      cp -r "$d" "$out/tldr-pages/$(basename "$d")"
    done
    if [ -d "$out/tldr-pages/pages" ] && [ ! -d "$out/tldr-pages/pages.en" ]; then
      mv "$out/tldr-pages/pages" "$out/tldr-pages/pages.en"
    fi
  '';
in {
  programs = {
    tealdeer = {
      enable = true; # Fast tldr client
      enableAutoUpdates = false;
      settings.directories.cache_dir = "${tealdeerCache}";
    };
    zsh.shellAliases."tldr" = "tldr --quiet";
  };
}
