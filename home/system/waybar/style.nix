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
  mauve = "#${c.base0E}";
  inactive = "#${c.base03}";
  highlight = "#${c.base02}";
  font-size = "${toString config.stylix.fonts.sizes.applications}px";
  font-size-clock = "${toString (config.stylix.fonts.sizes.applications + 2)}px";
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
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.35);
    }

    #clock,
    #tray,
    #custom-network,
    #bluetooth,
    #battery,
    #mpris {
        padding: 1px 14px;
    }

    #clock {
      font-size: ${font-size-clock};
    }

    #workspaces {
        padding: 1px 8px;
    }

    #pulseaudio {
        padding: 1px 8px 1px 6px;
    }

    #pulseaudio-slider {
        padding: 0 8px 0 2px;
    }

    #workspaces button {
        color: ${fg};
        font-size: ${font-size};
        border-radius: 100px;
        padding: 0 5px;
        margin: 0 1px;
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
        padding: 0 12px;
        margin: 0 1px;
    }

    #right-hidden {
        padding: 0 6px;
    }

    #custom-arrow-right {
        padding: 0 5px;
        font-size: ${toString (config.stylix.fonts.sizes.applications + 2)}px;
    }

    #power-profiles-daemon {
        margin-right: 4px;
    }

    #network.disabled,
    #bluetooth.disabled {
        padding: 0;
        margin: 0;
        min-width: 0;
    }

    #battery {
        color: ${green};
    }

    #battery.charging,
    #battery.full {
        color: ${green};
    }

    #network.ethernet,
    #network.wifi {
        color: ${cyan};
    }

    #bluetooth.on,
    #bluetooth.connected,
    #bluetooth {
        color: ${blue};
    }

    #battery.critical,
    #network.disconnected,
    #power-profiles-daemon.performance {
        color: ${red};
    }

    #battery.warning {
        color: ${yellow};
    }

    #power-profiles-daemon.power-saver {
        color: ${green};
    }

    #mpris {
        color: ${mauve};
    }

    #mpris.paused {
        color: ${inactive};
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

    slider {
        opacity: 0;
        box-shadow: none;
    }

    trough {
        min-width: 50px;
        min-height: 5px;
        border-radius: 8px;
        background: ${inactive};
    }

    trough highlight {
        border-radius: 8px;
        background-color: ${fg};
        background-image: none;
    }
  '';
}
