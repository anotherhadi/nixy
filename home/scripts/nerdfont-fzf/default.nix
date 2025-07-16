# - ## Nerdfont FZF
#-
#- This module provides a script to search for Nerd Fonts icons using fzf.
#-
#- - `nerdfont-fzf` - Search for Nerd Fonts icons using fzf.
{
  pkgs,
  config,
  ...
}: let
  nerdfont-fzf = pkgs.writeShellScriptBin "nerdfont-fzf" ''
    icons=$(${pkgs.jq}/bin/jq -r 'to_entries[] | "\(.key):\(.value.char)"' "/home/${config.var.username}/.config/nerdfont_glyphnames.json" | awk -F: '{print "\033[95m "$2" \033[0m "$1}')
    fzf_result=$(echo "$icons" | ${pkgs.fzf}/bin/fzf --ansi --border none | awk '{print $1}')
    if [ -z "$fzf_result" ]; then
      echo "No icon selected"
      exit 1
    fi

    echo "Copied to clipboard: $fzf_result"
    ${pkgs.wl-clipboard}/bin/wl-copy "$fzf_result"
  '';
in {
  home.packages = [nerdfont-fzf];

  xdg.configFile."nerdfont_glyphnames.json" = {
    source = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/ryanoasis/nerd-fonts/384b1825ea0037b0314f7f9c660a80c1ecdb219a/glyphnames.json";
      hash = "sha256-Ps0dyFcMs51RMTthBOVSOf/lafPV/53JxuNSKlmZ7cc=";
    };
  };
}
