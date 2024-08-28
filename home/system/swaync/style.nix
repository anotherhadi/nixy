{ config, ... }: {

  xdg.configFile."swaync/style.css" = {
    text = ''
      @define-color notif-bg #${config.var.theme.colors.bgalt};
      @define-color notif-fg #${config.var.theme.colors.fgalt};
      @define-color cc-bg #${config.var.theme.colors.bg};
      @define-color cc-fg #${config.var.theme.colors.fg};
      @define-color red #${config.var.theme.colors.c1};

      * {
        font-family: "${config.var.theme.font}";
        color: #${config.var.theme.colors.fg};
      }

      .notification-row {
        outline: none;
      }

      .notification-row:focus,
      .notification-row:hover {
        background: @notif-bg;
        opacity: 0.8;
      }

      .notification {
        border-radius: ${toString config.var.theme.rounding}px;
        margin: 6px 12px;
        box-shadow: 0 0 0 1px rgba(0, 0, 0, 0.3), 0 1px 3px 1px rgba(0, 0, 0, 0.7),
          0 2px 6px 2px rgba(0, 0, 0, 0.3);
        padding: 0;
      }

      .notification-content {
        background: transparent;
        padding: 6px;
        border-radius: 12px;
      }

      .close-button {
        background: @cc-bg;
        color: @cc-fg;
        text-shadow: none;
        padding: 0;
        border-radius: 100%;
        margin-top: 10px;
        margin-right: 16px;
        box-shadow: none;
        border: none;
        min-width: 24px;
        min-height: 24px;
      }

      .close-button:hover {
        box-shadow: none;
        background: @red;
        transition: all 0.15s ease-in-out;
        border: none;
      }

      .notification-default-action,
      .notification-action {
        padding: 4px;
        margin: 0;
        box-shadow: none;
        background: @cc-bg;
        color: @cc-fg;
      }

      .notification-default-action:hover,
      .notification-action:hover {
        -gtk-icon-effect: none;
        background: @noti-bg-hover;
      }

      .notification-default-action {
        border-radius: 12px;
      }

      /* When alternative actions are visible */
      .notification-default-action:not(:only-child) {
        border-bottom-left-radius: 0px;
        border-bottom-right-radius: 0px;
      }

      .notification-action {
        border-radius: 0px;
        border-top: none;
        border-right: none;
      }

      /* add bottom border radius to eliminate clipping */
      .notification-action:first-child {
        border-bottom-left-radius: 10px;
      }

      .notification-action:last-child {
        border-bottom-right-radius: 10px;
        border-right: 1px solid @noti-border-color;
      }

      .image {}

      .body-image {
        margin-top: 6px;
        background-color: white;
        border-radius: 12px;
      }

      .summary {
        font-size: 16px;
        font-weight: bold;
        background: transparent;
        color: white;
        text-shadow: none;
      }

      .time {
        font-size: 16px;
        font-weight: bold;
        background: transparent;
        color: white;
        text-shadow: none;
        margin-right: 18px;
      }

      .body {
        font-size: 15px;
        font-weight: normal;
        background: transparent;
        color: white;
        text-shadow: none;
      }

      /* The "Notifications" and "Do Not Disturb" text widget */
      .top-action-title {
        color: white;
        text-shadow: none;
      }

      .control-center {
        background-color: @cc-bg;
      }

      .control-center-list {
        background: transparent;
      }

      .floating-notifications {
        background: transparent;
      }

      /* Window behind control center and on all other monitors */
      .blank-window {
        background: transparent;
      }

      /*** Widgets ***/

      /* Title widget */
      .widget-title {
        margin: 8px;
        font-size: 1.5rem;
      }

      .widget-title>button {
        font-size: initial;
        color: white;
        text-shadow: none;
        background: @noti-bg;
        border: 1px solid @noti-border-color;
        box-shadow: none;
        border-radius: 12px;
      }

      .widget-title>button:hover {
        background: @noti-bg-hover;
      }

      /* DND widget */
      .widget-dnd {
        margin: 8px;
        font-size: 1.1rem;
      }

      .widget-dnd>switch {
        font-size: initial;
        border-radius: 12px;
        background: @noti-bg;
        border: 1px solid @noti-border-color;
        box-shadow: none;
      }

      .widget-dnd>switch:checked {
        background: @bg-selected;
      }

      .widget-dnd>switch slider {
        background: @noti-bg-hover;
        border-radius: 12px;
      }

      /* Label widget */
      .widget-label {
        margin: 8px;
      }

      .widget-label>label {
        font-size: 1.1rem;
      }

      /* Mpris widget */
      .widget-mpris {
        /* The parent to all players */
      }

      .widget-mpris-player {
        padding: 8px;
        margin: 8px;
      }

      .widget-mpris-title {
        font-weight: bold;
        font-size: 1.25rem;
      }

      .widget-mpris-subtitle {
        font-size: 1.1rem;
      }

      /* Volume and Brightness Widget*/

      .widget-volume {
        background-color: @noti-bg;
        padding: 4px 8px 8px 8px;
        margin: 0px 8px 8px 8px;
        border-bottom-left-radius: 12px;
        border-bottom-right-radius: 12px;
      }

      .widget-backlight {
        background-color: @noti-bg;
        padding: 8px 8px 4px 8px;
        margin: 8px 8px 0px 8px;
        border-top-left-radius: 12px;
        border-top-right-radius: 12px;
      }

      .KB {
        padding: 4px 8px 4px 8px;
        margin: 0px 8px 0px 8px;
        border-radius: 0;
      }

      .power-buttons{
        background-color: @noti-bg;
        padding: 8px;
        margin: 8px;
        border-radius: 12px;
      }


      .power-buttons>button {
        background: transparent;
        border: none;
      }

      .power-buttons>button:hover {
        background: @noti-bg-hover;
      }

      .widget-menubar>box>.menu-button-bar>button{
        border: none;
        background: transparent;
      }

      .topbar-buttons>button{
        border: none;
        background: transparent;
      }

      .widget-buttons-grid{
        padding: 8px;
        margin: 8px;
        border-radius: 12px;
        background-color: @noti-bg;
      }

      .widget-buttons-grid>flowbox>flowboxchild>button{
        background: @noti-bg;
        border-radius: 12px;
      }

      .widget-buttons-grid>flowbox>flowboxchild>button:hover {
        background: @noti-bg-hover;
      }

      .powermode-buttons{
        background-color: @noti-bg;
        padding: 8px;
        margin: 8px;
        border-radius: 12px;
      }

      .powermode-buttons>button {
        background: transparent;
        border: none;
      }

      .powermode-buttons>button:hover {
        background: @noti-bg-hover;
      }
    '';
  };
}
