{ pkgs, config, ... }:
let
  homedir = config.home.homeDirectory;

  nerdfont-fzf = pkgs.writeShellScriptBin "nerdfont-fzf" ''
    # Dependencies: jq, fzf, wl-copy, wget
    icons=$(jq -r 'to_entries[] | "\(.key):\(.value.char)"' "${homedir}/.config/nerdfont_glyphnames.json" | awk -F: '{print "\033[95m "$2" \033[0m "$1}')
    fzf_result=$(echo "$icons" | fzf --ansi | awk '{print $1}' || exit 1)

    echo "Copied to clipboard: $fzf_result"
    printf "$fzf_result" | wl-copy 
  '';

  nerdfont-fzf-fetch = pkgs.writeShellScriptBin "nerdfont-fzf-fetch" ''
    wget "https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/glyphnames.json" -O "glyphnames.json" || exit 1
    jq 'del(.METADATA)' "glyphnames.json"
  '';

in {
  home.packages = with pkgs; [ nerdfont-fzf nerdfont-fzf-fetch ];

  xdg.configFile."nerdfont_glyphnames.json" = {
    source = ../misc/nerdfont_glyphnames.json;
  };

}
