{ config, ... }: let
  c = config.lib.stylix.colors;
  fg = "#${c.base05}";
  module-bg = "#${c.base01}";
  tooltip-bg = "#${c.base01}";
  red = "#${c.base08}";
  yellow = "#${c.base0A}";
  green = "#${c.base0B}";
  blue = "#${c.base0D}";
  inactive = "#${c.base03}";
  highlight = "#${c.base02}";
in {
  programs.waybar.style = ''
    * {
        font-family: 'CaskaydiaCove Nerd Font Propo';
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
        font-size: 14px;
        color: ${fg};
    }

    #temperature,
    #bluetooth,
    #battery,
    #memory,
    #mpris,
    #cpu,
    #load {
        padding: 1px 7px;
        min-width: 0;
    }

    #network,
    #tray {
        padding: 1px 6px;
    }

    #backlight,
    #pulseaudio {
        padding: 1px 8px;
    }

    #pulseaudio {
        padding-left: 4px;
    }

    #backlight-slider,
    #pulseaudio-slider {
        padding: 0 7px 0 2px;
    }

    #workspaces,
    #bluetooth,
    #battery,
    #memory,
    #temperature,
    #cpu,
    #mpris,
    #load {
        margin: 0 3px;
    }

    #right,
    #left,
    #right-hidden-top,
    #left-hidden-top {
        padding: 2px 10px;
        border-radius: 15px;
        background: ${module-bg};
    }

    #right-hidden-top,
    #left-hidden-top {
        padding: 0 12px;
    }

    #right, #left {
        margin: 0 8px;
    }

    #clock {
        background: ${module-bg};
        padding: 1px 18px;
        border-radius: 15px;
    }

    #custom-ctlcenter {
        margin-left: 7px;
    }

    #power-profiles-daemon {
        margin-right: 7px;
    }

    #network.disabled,
    #bluetooth.disabled {
        padding: 0;
        margin: 0;
        min-width: 0;
    }

    #cpu.critical,
    #memory.critical,
    #battery.critical,
    #temperature.critical,
    #network.disconnected,
    #power-profiles-daemon.performance {
        color: ${red};
    }

    #cpu.warning,
    #memory.warning,
    #battery.warning,
    #temperature.warning {
        color: ${yellow};
        background: unset;
    }

    #power-profiles-daemon.power-saver {
        color: ${green};
    }

    #custom-start,
    #custom-ctlcenter {
        color: ${blue};
    }

    #workspaces button {
        color: ${fg};
        font-size: 14px;
        border-radius: 100%;
        padding: 0 2px;
        margin: 0 3px;
    }

    #workspaces button:hover {
        background: transparent;
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
