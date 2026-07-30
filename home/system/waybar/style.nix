{config, ...}: let
  c = config.lib.stylix.colors;
  fg = "#${c.base05}";
  module-bg = "#${c.base01}";
  tooltip-bg = "#${c.base01}";
  red = "#${c.base08}";
  yellow = "#${c.base0A}";
  green = "#${c.base0B}";
  blue = "#${c.base0D}";
  cyan = "#${c.base0C}";
  inactive = "#${c.base03}";
  highlight = "#${c.base02}";
  font-size = "${toString config.stylix.fonts.sizes.applications}px";
  font-size-clock = "${toString (config.stylix.fonts.sizes.applications + 2)}px";
  module-padding = "14px";
in {
  programs.waybar.style = ''
    * {
        font-family: '${config.stylix.fonts.sansSerif.name}';
        border: none;
        border-radius: 0;
        min-height: 0;
        margin: 0;
        padding: 0;
        text-shadow: none;
    }

    #waybar {
        font-weight: 700;
        background: transparent;
        font-size: ${font-size};
        color: ${fg};
    }

    .modules-center {
        background: ${module-bg};
        border-radius: 100px;
        padding: 6px 14px;
        box-shadow: none;
    }

    #clock,
    #battery,
    #tray,
    #workspaces,
    #custom-osd,
    #custom-network,
    #custom-bluetooth {
        padding: 1px ${module-padding};
    }

    #custom-osd-sep {
        padding: 0;
        color: ${inactive};
    }

    #tray.empty {
        padding: 0;
    }

    #clock {
      font-size: ${font-size-clock};
    }

    #workspaces button {
        color: ${fg};
        font-size: ${font-size};
        border-radius: 100px;
        padding: 0 3px;
        margin: 0;
    }

    #workspaces button.empty {
        color: ${inactive};
    }

    #workspaces button:hover {
        background: transparent;
        color: ${fg};
    }

    #workspaces button.active {
        color: ${module-bg};
        background: ${blue};
        border-radius: 60px;
        padding: 0 8px;
        margin: 0;
    }

    #battery {
        color: ${green};
    }

    #battery.charging,
    #battery.full {
        color: ${green};
    }

    #battery.critical,
    #custom-network.disconnected {
        color: ${red};
    }

    #battery.warning {
        color: ${yellow};
    }

    #custom-network.ethernet,
    #custom-network.wifi {
        color: ${cyan};
    }

    #custom-bluetooth {
        color: ${blue};
    }

    #custom-bluetooth.off {
        color: ${inactive};
    }

    #custom-osd {
        font-weight: 700;
        color: ${fg};
    }

    tooltip {
        border-radius: 15px;
        background: ${tooltip-bg};
    }

    tooltip label {
        padding: 3px 10px;
        color: ${fg};
        font-weight: 700;
    }

    .popup * {
        box-shadow: none;
        outline: none;
        border-radius: 10px;
    }

    menu {
        border-radius: 10px;
        font-weight: 700;
        color: ${fg};
        background: ${tooltip-bg};
    }

    menu > * {
        padding: 3px 0px;
    }

    menu > *:hover {
        border-radius: 10px;
        background-color: ${highlight};
    }
  '';
}
