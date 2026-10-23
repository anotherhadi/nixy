# Picker scripts built on tofi's dmenu mode
{config, ...}: let
  inherit (config) theme;
in {
  flake.modules.nixos.desktop.hjem.extraModules = [
    ({
      pkgs,
      scripts,
      ...
    }: let
      tofiMenu = "${scripts.tofi-menu}/bin/tofi-menu";

      nerdFontGlyphnames = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/ryanoasis/nerd-fonts/v3.4.0/glyphnames.json";
        sha256 = "sha256-4tENI/W/8L1vBnbpsB2XifzcZW3ntJiilVwncW6kQ5w=";
      };
      nerdFontIconList = pkgs.runCommand "nerd-font-icons.txt" {nativeBuildInputs = [pkgs.jq];} ''
        jq -r 'to_entries[] | select(.key != "METADATA") | "\(.value.char)  \(.key)"' \
          ${nerdFontGlyphnames} > "$out"
      '';
    in {
      scripts.emoji-picker = pkgs.writeShellScriptBin "emoji-picker" ''
        export PATH="${pkgs.wtype}/bin:${pkgs.wl-clipboard}/bin:$PATH"
        export BEMOJI_PICKER_CMD="${tofiMenu} --prompt-text 'emoji: '"
        # -t types the emoji, -c also copies it.
        exec ${pkgs.bemoji}/bin/bemoji -t -c
      '';

      scripts.icon-picker = pkgs.writeShellScriptBin "icon-picker" ''
        selected=$(${tofiMenu} --font "${theme.fonts.monospace}" --prompt-text 'icon: ' < ${nerdFontIconList})
        [ -z "$selected" ] || icon=$(printf '%s\n' "$selected" | awk '{print $1}')
        [ -n "''${icon:-}" ] || exit 0
        ${pkgs.wtype}/bin/wtype "$icon"
        printf '%s' "$icon" | ${pkgs.wl-clipboard}/bin/wl-copy
      '';

      launcher.emoji-picker.name = "Emoji Picker";
      launcher.icon-picker.name = "Icon Picker";

      packages = with pkgs; [bemoji wtype];
    })
  ];
}
