{config, ...}: let
  c = config.lib.stylix.colors;
  font = config.stylix.fonts.sansSerif.name;
  monofont = config.stylix.fonts.monospace.name;
  rounding = config.theme.rounding;
  border-size = config.theme.border-size;
  gaps-in = config.theme.gaps-in;
  opacityToHex = opacity: let
    val = builtins.floor (opacity * 255);
    high = val / 16;
    low = val - high * 16;
    digits = "0123456789abcdef";
  in "${builtins.substring high 1 digits}${builtins.substring low 1 digits}";
  alphaHex = opacityToHex config.theme.inactive-opacity;
in {
  services.swaync = {
    enable = true;

    settings = {
      positionX = "right";
      positionY = "top";
      cssPriority = "user";
      "control-center-width" = 450;
      "fit-to-screen" = true;
      "notification-window-width" = 400;
      "notification-icon-size" = 40;
      "notification-body-image-height" = 500;
      "notification-body-image-width" = 500;
      "notification-inline-replies" = true;
      "notification-2fa-action" = false;
      timeout = 3;
      "timeout-low" = 2;
      "timeout-critical" = 6;
      "keyboard-shortcuts" = true;
      "image-visibility" = "when-available";
      "transition-time" = 200;
      "hide-on-clear" = false;
      "hide-on-action" = false;
      "script-fail-notify" = true;
      widgets = ["mpris" "dnd" "buttons-grid" "notifications"];
      "widget-config" = {
        dnd.text = "Do not disturb";
        mpris = {
          "image-size" = 100;
          "image-radius" = 10;
          autohide = false;
          blacklist = ["org.mpris.MediaPlayer2.playerctld"];
        };
        "buttons-grid" = {
          actions = [
            {
              label = "󰖔";
              type = "toggle";
              command = "nightshift-toggle";
              "update-command" = "pidof hyprsunset > /dev/null && echo true || echo false";
            }
            {
              label = "󰈈";
              type = "toggle";
              command = "focus-toggle";
              "update-command" = "test -f /tmp/hypr-focus-mode && echo true || echo false";
            }
            {
              label = "󰍭";
              type = "toggle";
              command = "swayosd-client --input-volume mute-toggle";
              "update-command" = "wpctl get-volume @DEFAULT_SOURCE@ | grep -q MUTED && echo true || echo false";
            }
            {
              label = "󰌾";
              command = "swaync-client -cp ; hyprlock";
            }
            {
              label = "󰐥";
              command = "swaync-client -cp ; systemctl poweroff";
            }
          ];
        };
      };
    };

    style = ''
      @define-color center-bg              #${c.base00}${alphaHex};
      @define-color notification-bg        #${c.base00}${alphaHex};
      @define-color center-notification-bg #${c.base01};
      @define-color background             #${c.base00}${alphaHex};
      @define-color background-alt         #${c.base01};
      @define-color text                   #${c.base05};
      @define-color text-alt               #${c.base03};
      @define-color selected               #${c.base03}66;
      @define-color hover                  #${c.base03}28;
      @define-color urgent                 #${c.base08};

      * {
        all: unset;
        font-family: "${font}";
        font-weight: 700;
        --border-radius: ${toString rounding}px;
        --border-radius-s: ${toString gaps-in}px;
        --border-radius-xl: ${toString (rounding - 2)}px;
        --shadow: 2px 4px 10px rgba(0,0,0,0.15);
      }

      .notification { padding: 5px; }

      .notification-row { background: transparent; border: none; box-shadow: none; }

      .control-center .notification { padding: 0; }

      .notification-background {
        background: @notification-bg;
        border-radius: var(--border-radius);
        border: ${toString border-size}px solid @selected;
        box-shadow: none;
        outline: none;
        margin: ${toString gaps-in}px;
        padding: 0;
      }

      .notification-background .close-button {
        margin: 6px;
        padding: 2px;
        border-radius: ${toString (gaps-in - 2)}px;
        background: transparent;
        color: @text;
      }

      .notification-background .close-button:hover { background: @hover; }

      .notification.low,
      .notification.normal { border: none; }

      .notification.critical {
        border: ${toString border-size}px solid @urgent;
        border-radius: var(--border-radius);
      }

      .notification-content {
        color: @text;
        margin: 10px;
        font-weight: 700;
        border: none;
      }

      .notification-content .text-box { margin: 0 0 0 15px; }

      .notification-content .time {
        padding: 2px;
        font-size: 0.95rem;
        font-weight: 800;
      }

      .notification-content .summary {
        font-size: 1rem;
        font-weight: 800;
        padding: 2px 0;
        margin-bottom: 2px;
      }

      .notification-content .body {
        color: @text-alt;
        font-size: 0.8rem;
      }

      .notification-row .inline-reply-entry,
      .notification-row .inline-reply-button {
        margin: 5px -5px -5px -5px;
        padding: 10px 15px;
        border-radius: var(--border-radius);
        background: @background-alt;
      }

      .notification-row .inline-reply-entry { margin-right: 10px; }
      .notification-row .inline-reply-button:hover { background: @selected; }

      .notification-alt-actions { padding: 5px 0; }

      .notification-action {
        font-weight: 700;
        border-radius: var(--border-radius);
        background: @hover;
        color: @text;
        margin: 0 5px;
        padding: 10px 0;
      }

      .notification-action:hover,
      .notification-action:active { background: @selected; }

      .control-center {
        background: @center-bg;
        border-radius: var(--border-radius);
        border: ${toString border-size}px solid @selected;
        margin: 5px;
        padding: 5px 5px 0 5px;
      }

      .control-center .notification-background {
        background: @center-notification-bg;
        box-shadow: var(--shadow);
      }

      .control-center .notification-background .close-button,
      .notification-group-close-button { opacity: 0; }

      .notification-group { transition: 200ms; }

      .notification-group:not(.collapsed) { margin: ${toString gaps-in}px; }

      .notification-group-headers,
      .notification-group-buttons {
        color: @text;
        font-weight: bold;
        background: @background;
        border-radius: var(--border-radius);
        padding: 4px 8px;
      }

      .notification-group-headers > label {
        margin: 0 3px;
        font-size: 1rem;
      }

      .notification-group-icon { color: @text; }

      .notification-group-buttons .image-button {
        background: transparent;
        color: @text;
        padding: 4px;
        border-radius: var(--border-radius);
      }

      .notification-group-buttons .image-button:hover { background: @hover; }

      .widget {
        margin: 5px;
        color: @text;
      }

      .widget-mpris-album-art {
        border-radius: var(--border-radius);
        margin: 6px 4px;
      }

      .widget-mpris-title {
        font-weight: 700;
        font-size: 1.2rem;
        margin: 0 3px;
      }

      .widget-mpris-subtitle {
        color: @text-alt;
        font-weight: 700;
        font-size: 0.9rem;
        margin: 0 3px;
      }

      .mpris-background { border-radius: 14px; margin: 3px; }

      .widget-mpris {
        border-radius: var(--border-radius);
        box-shadow: var(--shadow);
      }

      .mpris-overlay {
        border-radius: var(--border-radius);
        padding: 10px;
        background: @background;
      }

      .mpris-overlay > box:last-child {
        border-radius: var(--border-radius-xl);
        padding: 0 5px;
        background: alpha(@hover, .6);
      }

      .widget-mpris-player button {
        padding: 5px;
        margin: 0 2.5px;
      }

      .widget-mpris-player button:hover {
        border-radius: var(--border-radius-s);
        background: @hover;
      }

      .widget-dnd {
        padding: 10px 15px;
        border-radius: var(--border-radius);
        background: @background-alt;
        box-shadow: var(--shadow);
        color: @text;
      }

      .widget-dnd > label {
        font-size: 1rem;
        font-weight: 700;
      }

      .widget-dnd switch {
        background: @hover;
        border-radius: var(--border-radius-s);
        box-shadow: none;
        padding: 2px;
        transition: 200ms;
      }

      .widget-dnd switch slider {
        background: @text;
        border-radius: var(--border-radius-s);
      }

      .widget-dnd switch:hover,
      .widget-dnd switch:checked { background-color: @selected; }

      .widget-notifications { margin: 0; }

      .widget-buttons-grid {
        border-radius: var(--border-radius);
        padding: 5px 15px;
        margin-bottom: 5px;
        background: @background-alt;
        box-shadow: var(--shadow);
      }

      .widget-buttons-grid button {
        padding: 10px;
        margin: 3px;
        min-width: 2rem;
        font-family: "${monofont}";
        background: @hover;
        border-radius: var(--border-radius);
        transition: 200ms;
      }

      .widget-buttons-grid button > label {
        font-family: "${monofont}";
        font-size: 18px;
        font-weight: normal;
        font-style: normal;
        color: @text;
      }

      .widget-buttons-grid button:hover { background: @selected; }

      .widget-buttons-grid button:checked { background-color: @text; }

      .widget-buttons-grid button:checked > label { color: @background; }

      .control-center-list-placeholder { color: @text; }

      .blank-window { background: transparent; }
    '';
  };

  stylix.targets.swaync.enable = false;
}
