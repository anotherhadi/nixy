{ config, pkgs, ... }: let
  c = config.lib.stylix.colors;
  font = config.stylix.fonts.sansSerif.name;
  theme = pkgs.writeText "launcher.rasi" ''
    configuration {
      modi:                  "drun,run,window";
      case-sensitive:        false;
      cycle:                 true;
      normalize-match:       true;
      show-icons:            true;
      matching:              "normal";
      tokenize:              true;
      kb-cancel:             "Escape,MousePrimary";
      drun-match-fields:     "name,exec,generic,comment";
      drun-display-format:   "{name} \n[<span size='small'><i>{comment}</i></span>]";
      drun-url-launcher:     "xdg-open";
      drun-show-actions:     false;
      disable-history:       false;
      sorting-method:        "normal";
      terminal:              "ghostty";
      hover-select:          true;
      me-select-entry:       "";
      me-accept-entry:       [ "MousePrimary" ];
      timeout {
        action: "kb-cancel";
        delay:  0;
      }
    }

    * {
      background:     #${c.base00}e5;
      background-alt: #${c.base01}ff;
      background-sec: #${c.base03}ff;
      foreground:     #${c.base05}ff;
      selected:       #${c.base05}ff;
      active:         #${c.base0B}ff;
      urgent:         #${c.base08}ff;
      highlight:      #${c.base03}28;
      font:           "${font}, bold 12";
    }

    window {
      transparency:     "real";
      location:         west;
      anchor:           west;
      padding:          0;
      margin:           5px;
      border-radius:    15px;
      width:            450px;
      height:           100%;
      background-color: @background;
    }

    mainbox {
      border-radius:    0;
      margin:           0;
      spacing:          10px;
      padding:          10px;
      background-color: transparent;
      children:         [ "inputbar", "message", "listview", "mode-switcher" ];
    }

    inputbar {
      spacing:          10px;
      margin:           0px;
      padding:          10px 15px;
      border-radius:    16px;
      background-color: @background-alt;
      color:            @foreground;
      children:         [ "entry" ];
    }

    entry {
      background-color:  inherit;
      color:             inherit;
      placeholder-color: inherit;
      placeholder:       "Search...";
    }

    listview {
      columns:          1;
      dynamic:          true;
      scrollbar:        false;
      layout:           vertical;
      reverse:          false;
      fixed-height:     true;
      fixed-columns:    true;
      spacing:          5px;
      margin:           0px;
      padding:          10px 8px;
      border-radius:    16px;
      background-color: @background-alt;
      color:            @foreground;
    }

    element {
      enabled:          true;
      spacing:          8px;
      margin:           0px;
      padding:          3px 10px;
      border-radius:    16px;
      background-color: transparent;
      color:            @foreground;
      cursor:           pointer;
    }

    element selected.normal {
      background-color: @highlight;
    }

    element-icon {
      background-color: transparent;
      size:             26px;
      margin:           0 5px 0 0;
      color:            inherit;
      cursor:           inherit;
    }

    element-text {
      background-color: transparent;
      color:            inherit;
      cursor:           inherit;
      padding:          10px 0;
      vertical-align:   0.5;
    }

    mode-switcher {
      enabled:          true;
      spacing:          8px;
      margin:           0px;
      border-radius:    16px;
      padding:          8px 18px;
      background-color: @background-alt;
      color:            @foreground;
    }

    button {
      padding:          10px;
      margin:           0;
      border:           0px solid;
      border-radius:    16px;
      background-color: @highlight;
      color:            inherit;
      cursor:           pointer;
    }

    button selected {
      background-color: @foreground;
      color:            @background;
    }

    message {
      enabled:          true;
      margin:           0px;
      padding:          0px;
      border-radius:    0px;
      background-color: transparent;
      color:            @foreground;
    }

    textbox {
      padding:           8px;
      border-radius:     4px;
      background-color:  @background-alt;
      color:             @foreground;
      placeholder-color: @foreground;
      vertical-align:    0.5;
      blink:             true;
      markup:            true;
    }

    error-message {
      padding:          10px;
      border-radius:    0px;
      background-color: @background;
      color:            @foreground;
    }
  '';
in {
  stylix.targets.rofi.enable = false;

  programs.rofi = {
    enable = true;
    theme = "${theme}";
  };
}
