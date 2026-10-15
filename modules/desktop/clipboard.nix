# Clipboard history: cliphist watches the Wayland clipboard and stores every entry
{
  flake.modules.nixos.desktop.hjem.extraModules = [
    ({
      lib,
      pkgs,
      scripts,
      ...
    }: let
      tofiMenu = "${pkgs.tofi}/bin/tofi --horizontal false --anchor center --width 700 --height 500 --margin-top 0 --margin-left 0 --margin-right 0 --num-results 10";
      cliphist = "${pkgs.cliphist}/bin/cliphist";

      mkWatcher = description: type: {
        inherit description;
        after = ["graphical-session.target"];
        partOf = ["graphical-session.target"];
        wantedBy = ["graphical-session.target"];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste ${lib.optionalString (type != null) "--type ${type} "}--watch ${cliphist} -max-dedupe-search 10 -max-items 500 store";
          Restart = "on-failure";
        };
      };
    in {
      scripts.clipboard-menu = pkgs.writeShellScriptBin "clipboard-menu" ''
        list=$(${cliphist} list)
        selected=$(printf '%s\n' "$list" | cut -f2- | ${tofiMenu} --prompt-text "Clipboard: ")
        [ -n "$selected" ] && printf '%s\n' "$list" \
          | awk -F'\t' -v s="$selected" '$2 == s {print; exit}' \
          | ${cliphist} decode \
          | ${pkgs.wl-clipboard}/bin/wl-copy
      '';

      packages = [
        pkgs.wl-clipboard
        pkgs.cliphist
        scripts.clipboard-menu
        (pkgs.makeDesktopItem {
          name = "clipboard-menu";
          desktopName = "Clipboard History";
          exec = "${scripts.clipboard-menu}/bin/clipboard-menu";
          icon = "edit-paste-symbolic";
          comment = "Pick a past clipboard entry";
          categories = ["Utility"];
          terminal = false;
          keywords = ["clipboard" "history" "paste" "cliphist"];
        })
        (pkgs.makeDesktopItem {
          name = "clipboard-wipe";
          desktopName = "Clear Clipboard History";
          exec = "${cliphist} wipe";
          icon = "edit-clear-all-symbolic";
          comment = "Delete all clipboard history entries";
          categories = ["Utility"];
          terminal = false;
          keywords = ["clipboard" "history" "clear" "wipe" "delete" "cliphist"];
        })
      ];

      systemd.services = {
        cliphist = mkWatcher "Clipboard management daemon" null;
        cliphist-images = mkWatcher "Clipboard management daemon - images" "image";

        cliphist-wipe = {
          description = "Wipe cliphist history on login and logout";
          after = ["cliphist.service"];
          wantedBy = ["default.target"];
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            ExecStart = "${cliphist} wipe";
            ExecStop = "${cliphist} wipe";
          };
        };
      };
    })
  ];
}
