# Elio is a TUI file explorer
# TODO: Test browser save-as/chosser-file after sandboxing
{
  aspects,
  inputs,
  config,
  ...
}: let
  inherit (config.flake.lib) mkSandbox mime;
  c = config.theme.withHashtag;
in {
  flake.modules.nixos.elio = {
    imports = [aspects.hjem];

    # User side, applied to every hjem user of the host
    hjem.extraModules = [
      ({
        pkgs,
        lib,
        ...
      }: let
        # Sandboxed: no network, no D-Bus, secrets hidden, NixOS config read-only.
        # Everything elio spawns (previewers, $EDITOR, xdg-open) inherits the sandbox.
        elio = (mkSandbox pkgs).wrap {
          package = inputs.elio.packages.${pkgs.stdenv.hostPlatform.system}.elio;
          config = {sloth, ...}: {
            bubblewrap = {
              bind.rw = [
                sloth.homeDir
                "/tmp" # termfilechooser portal writes the chosen path here
              ];
              bind.ro = [(sloth.concat' sloth.homeDir "/.config/nixos")];
              sockets.wayland = true; # wl-copy, GUI apps opened from elio
            };
          };
        };
      in {
        packages = [
          elio
          pkgs.poppler-utils # PDF previews
          pkgs.ffmpeg # media metadata and thumbnails
          pkgs.resvg # SVG previews
          (lib.hiPrio (pkgs.makeDesktopItem {
            name = "elio";
            desktopName = "Files";
            exec = "${pkgs.ghostty}/bin/ghostty +new-window -e ${elio}/bin/elio %f";
            terminal = false;
            mimeTypes = ["inode/directory"];
            categories = ["System" "FileManager" "FileTools" "ConsoleOnly"];
            keywords = ["elio" "file" "explorer"];
          }))
        ];

        # Default file manager and archive handler
        xdg.mime-apps = mime.defaultFor "elio.desktop" (mime.types.directory ++ mime.types.archive);

        files = {
          ".config/elio/config.toml".text = ''
            [places]
            show_devices = false
            entries = [
              "home",
              "documents",
              "downloads",
              "pictures",
              { title = "Notes", path = "~/Notes" },
              { title = "Cyber", path = "~/Cyber" },
              { title = "Projects", path = "~/Projects" },
              { title = "NixOS Config", path = "~/.config/nixos" },
              "trash",
            ]
          '';

          ".config/elio/theme.toml".text = ''
            [palette]
            bg = "${c.base00}"
            chrome = "${c.base01}"
            chrome_alt = "${c.base01}"
            chip_text = "${c.base00}"
            panel = "${c.base00}"
            panel_alt = "${c.base00}"
            surface = "${c.base02}"
            elevated = "${c.base02}"
            border = "${c.base03}"
            text = "${c.base05}"
            muted = "${c.base04}"
            accent = "${c.base0D}"
            accent_soft = "${c.base02}"
            accent_text = "${c.base06}"
            selected_bg = "${c.base02}"
            selected_border = "${c.base0D}"
            selection_bar = "${c.base09}"
            yank_bar = "${c.base0B}"
            cut_bar = "${c.base08}"
            progress_bar = "${c.base0D}"
            grid_selection_band = "${c.base02}"
            grid_yank_band = "${c.base01}"
            grid_cut_band = "${c.base01}"
            sidebar_active = "${c.base02}"
            button_bg = "${c.base01}"
            button_disabled_bg = "${c.base01}"
            path_bg = "${c.base00}"

            [preview.code]
            fg = "${c.base05}"
            bg = "${c.base01}"
            selection_bg = "${c.base02}"
            selection_fg = "${c.base06}"
            caret = "${c.base0C}"
            line_highlight = "${c.base01}"
            line_number = "${c.base03}"
            comment = "${c.base03}"
            string = "${c.base0B}"
            constant = "${c.base09}"
            keyword = "${c.base0E}"
            function = "${c.base0D}"
            type = "${c.base0A}"
            parameter = "${c.base08}"
            tag = "${c.base0C}"
            operator = "${c.base0C}"
            macro = "${c.base0F}"
            invalid = "${c.base08}"
          '';
        };
      })
    ];
  };
}
