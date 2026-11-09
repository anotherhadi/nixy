# ilovetui theme, follows the global palette
{
  aspects,
  config,
  ...
}: let
  c = config.theme.withHashtag;
in {
  flake.modules.nixos.ilovetui = {
    imports = [aspects.hjem];

    hjem.extraModules = [
      {
        xdg.config.files."ilovetui/config.yaml".text = ''
          mouse: true
          nerd-fonts: true
          emoji: true
          spacious: true
          help-bar: true
          border-style: rounded

          colors:
            base00: "${c.base00}"
            base01: "${c.base01}"
            base02: "${c.base02}"
            base03: "${c.base03}"
            base04: "${c.base04}"
            base05: "${c.base05}"
            base06: "${c.base06}"
            base07: "${c.base07}"
            base08: "${c.base08}"
            base09: "${c.base09}"
            base0A: "${c.base0A}"
            base0B: "${c.base0B}"
            base0C: "${c.base0C}"
            base0D: "${c.base0D}"
            base0E: "${c.base0E}"
            base0F: "${c.base0F}"
            base10: "${c.base10}"
            base11: "${c.base11}"
            base12: "${c.base12}"
            base13: "${c.base13}"
            base14: "${c.base14}"
            base15: "${c.base15}"
            base16: "${c.base16}"
            base17: "${c.base17}"
        '';
      }
    ];
  };
}
