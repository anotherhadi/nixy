{ pkgs, config, ... }:
let
  homedir = config.home.homeDirectory;

  nerdfont-fzf = pkgs.writeShellScriptBin "nerdfont-fzf" ''
    # Dependencies: jq, fzf, wl-copy, wget
    icons=$(jq -r 'to_entries[] | "\(.key):\(.value.char)"' "${homedir}/.config/nerdfont_glyphnames.json" | awk -F: '{print "\033[95m "$2" \033[0m "$1}')
    fzf_result=$(echo "$icons" | fzf --ansi --border none | awk '{print $1}')
    if [ -z "$fzf_result" ]; then
      echo "No icon selected"
      exit 1
    fi

    echo "Copied to clipboard: $fzf_result"
    echo "Paste it to close the window"
    ${pkgs.wl-clipboard}/bin/wl-copy -o "$fzf_result" # wait for paste before exiting.. not cool
  '';

  nerdfont-fzf-fetch = pkgs.writeShellScriptBin "nerdfont-fzf-fetch" ''
    wget "https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/glyphnames.json" -O "glyphnames.json" || exit 1
    jq 'del(.METADATA)' "glyphnames.json"
  '';

  nerdfont-popup = pkgs.writeShellScriptBin "nerdfont-popup" ''
    ${pkgs.kitty}/bin/kitty --class floating -o font_size=18 zsh -c nerdfont-fzf 2>/dev/null
  '';

in {
  home.packages = with pkgs; [ nerdfont-fzf nerdfont-fzf-fetch nerdfont-popup ];

  xdg.configFile."nerdfont_glyphnames.json" = {
    source = ../misc/nerdfont_glyphnames.json;
  };

}
