# Clipboard history: cliphist watches the Wayland clipboard and stores every entry
{
  flake.modules.nixos.desktop.hjem.extraModules = [
    ({
      lib,
      pkgs,
      scripts,
      ...
    }: let
      tofiMenu = "${scripts.tofi-menu}/bin/tofi-menu";
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

      packages = [pkgs.wl-clipboard pkgs.cliphist];

      launcher = {
        clipboard-menu.name = "Clipboard History";
        clipboard-wipe = {
          name = "Clear Clipboard History";
          exec = "${cliphist} wipe";
        };
      };

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
