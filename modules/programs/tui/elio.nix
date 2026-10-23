# Elio: Snappy, batteries-included TUI file manager.
{
  aspects,
  inputs,
  config,
  ...
}: let
  inherit (config.flake.lib) mkSandbox mime;
  c = config.theme.withHashtag;
in {
  flake.modules.nixos.elio = {pkgs, ...}: let
    elioPkg = inputs.elio.packages.${pkgs.stdenv.hostPlatform.system}.elio;

    # Sandboxed: no network, D-Bus only to the portal, secrets hidden, NixOS config read-only.
    # Everything elio spawns directly (previewers, "open with") inherits the sandbox.
    elio = (mkSandbox pkgs).wrap {
      package = elioPkg;
      config = {sloth, ...}: {
        # Files are opened through the portal (xdg-open -> OpenURI.OpenFile): the default app
        # starts outside this sandbox, in its own, instead of inheriting this one
        dbus = {
          enable = true;
          policies."org.freedesktop.portal.Desktop" = "talk";
        };
        bubblewrap = {
          env.NIXOS_XDG_OPEN_USE_PORTAL = "1";
          bind.rw = [sloth.homeDir];
          bind.ro = [
            (sloth.concat' sloth.homeDir "/.config/nixos")
            (sloth.concat' sloth.runtimeDir "/elio/portal") # File chooser socket to the portal service
          ];
          sockets.wayland = true; # wl-copy, GUI apps opened from elio
        };
      };
    };

    elioPortal = let
      service = pkgs.writeShellScript "elio-portal-service" ''
        export PATH=${pkgs.ghostty}/bin:$PATH
        exec -a ${elio}/bin/elio ${elioPkg}/bin/elio --portal-service
      '';
    in
      pkgs.runCommandLocal "elio-portal" {} ''
        mkdir -p $out/share/xdg-desktop-portal/portals $out/share/dbus-1/services
        cat > $out/share/xdg-desktop-portal/portals/elio.portal <<EOF
        [portal]
        DBusName=io.github.elio_fm.elio.Portal
        Interfaces=org.freedesktop.impl.portal.FileChooser;
        EOF
        cat > $out/share/dbus-1/services/io.github.elio_fm.elio.Portal.service <<EOF
        [D-BUS Service]
        Name=io.github.elio_fm.elio.Portal
        Exec=${service}
        EOF
      '';
  in {
    imports = [aspects.hjem];

    xdg.portal = {
      config.sway."org.freedesktop.impl.portal.FileChooser" = ["elio"];
      extraPortals = [elioPortal];
    };

    hjem.extraModules = [
      ({lib, ...}: {
        packages = [
          elio
          pkgs._7zz # Archives
          pkgs.poppler-utils # PDF previews
          pkgs.ffmpeg-headless # media metadata and thumbnails
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

            [goto]
            entries = [
              "top",
              { builtin = "downloads", key = "D" },
              "home",
              { builtin = "config", key = "C" },
              { title = "notes", path = "~/Notes", key = "n" },
              { title = "cyber", path = "~/Cyber", key = "c" },
              { title = "projects", path = "~/Projects", key = "p" },
              { title = "tmp", path = "/tmp", key = "T" },
              { title = "repo root", command = "git rev-parse --show-toplevel", key = "r" },
            ]

            [portal]
            terminal = "ghostty"
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
            sidebar_active = "${c.base02}"
            button_bg = "${c.base01}"
            button_disabled_bg = "${c.base01}"
            path_bg = "${c.base00}"
            trash_bar = "${c.base12}"
            restore_bar = "${c.base16}"

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

            [classes.directory]
            color = "${c.base0D}"

            [classes.symlink_directory]
            color = "${c.base16}"

            [classes.broken_symlink]
            color = "${c.base08}"

            [classes.code]
            color = "${c.base0C}"

            [classes.config]
            color = "${c.base0E}"

            [classes.document]
            color = "${c.base0B}"

            [classes.license]
            color = "${c.base0A}"

            [classes.image]
            color = "${c.base15}"

            [classes.audio]
            color = "${c.base09}"

            [classes.video]
            color = "${c.base17}"

            [classes.archive]
            color = "${c.base12}"

            [classes.font]
            color = "${c.base13}"

            [classes.data]
            color = "${c.base14}"

            [classes.file]
            color = "${c.base05}"
          '';
        };
      })
    ];
  };
}
