# sectui: TUIs cybersecurity tools
{
  aspects,
  config,
  ...
}: let
  c = config.theme.withHashtag;
in {
  flake.modules.nixos.sectui = {
    imports = [aspects.hjem];

    hjem.extraModules = [
      ({
        lib,
        pkgs,
        ...
      }: let
        sectui = pkgs.nur.repos.sectui;
      in {
        config = lib.mkMerge [
          {
            packages = [sectui.operations sectui.steep];

            xdg.config.files."steep/config.yaml".text = ''
              createCollection: false
              pickerDir: "~/Cyber/wordlists/"
              layout:
                collection: hidden
              screenshot:
                onCapture: wl-copy < "$SCREENSHOT"
            '';

            xdg.config.files."sectui/config.yaml".text = ''
              transparentBackground: true
              colors:
                base00: "${c.base00}" # Background
                base01: "${c.base01}" # Lighter Background / Status Bars
                base02: "${c.base02}" # Selection Background
                base03: "${c.base03}" # Comments / Invisibles
                base04: "${c.base04}" # Dark Foreground / Status Bars
                base05: "${c.base05}" # Default Foreground
                base06: "${c.base06}" # Light Foreground
                base07: "${c.base07}" # Light Background
                base08: "${c.base08}" # Variables / Errors / Diff Deleted
                base09: "${c.base09}" # Integers / Constants / Booleans
                base0A: "${c.base0A}" # Classes / Warnings / Search Background
                base0B: "${c.base0B}" # Strings / Success / Diff Inserted
                base0C: "${c.base0C}" # Support / Regex / Escape Characters
                base0D: "${c.base0D}" # Functions / Methods / Headings / Accent
                base0E: "${c.base0E}" # Keywords / Storage / Diff Changed
                base0F: "${c.base0F}" # Embedded / Misc
                base10: "${c.base10}" # darker background
                base11: "${c.base11}" # darkest background
                base12: "${c.base12}" # bright red
                base13: "${c.base13}" # bright yellow
                base14: "${c.base14}" # bright green
                base15: "${c.base15}" # bright cyan
                base16: "${c.base16}" # bright blue
                base17: "${c.base17}" # bright magenta
            '';
          }
        ];
      })
    ];
  };
}
