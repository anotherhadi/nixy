# Night Shift: reduce blue light
{
  flake.modules.nixos.desktop.hjem.extraModules = [
    ({
      pkgs,
      scripts,
      ...
    }: {
      scripts.nightshift-toggle = pkgs.writeShellScriptBin "nightshift-toggle" ''
        if ${pkgs.procps}/bin/pkill -x wlsunset; then
          OSD_TEXT="󰖔  Night Shift Off"
        else
          ${pkgs.wlsunset}/bin/wlsunset -t 4500 -T 4501 -l 0 -L 0 >/dev/null 2>&1 &
          OSD_TEXT="󰖔  Night Shift On"
        fi
        ${scripts.osd}/bin/osd "$OSD_TEXT" nightshift
      '';

      launcher.nightshift-toggle.name = "Night Shift";
    })
  ];
}
