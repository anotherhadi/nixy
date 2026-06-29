{ config, pkgs, ... }: let
  c = config.lib.stylix.colors;
  font = config.stylix.fonts.sansSerif.name;
  fontSize = toString config.stylix.fonts.sizes.applications;
  gaps = toString config.theme.gaps-out;
  theme = pkgs.writeText "launcher.rasi" ''
    configuration {
      modi:                  "drun,run";
      case-sensitive:        false;
      cycle:                 true;
      normalize-match:       true;
      show-icons:            false;
      matching:              "normal";
      tokenize:              true;
      kb-cancel:             "Escape,MousePrimary";
      drun-match-fields:     "name,exec,generic,comment";
      drun-display-format:   "{name}";
      drun-url-launcher:     "xdg-open";
      drun-show-actions:     false;
      disable-history:       false;
      sorting-method:        "normal";
      terminal:              "ghostty";
      hover-select:          true;
      me-select-entry:       "";
      me-accept-entry:       [ "MousePrimary" ];
    }

    * {
      background:     transparent;
      background-alt: #${c.base01}ff;
      foreground:     #${c.base05}ff;
      active:         #${c.base0D}ff;
      inactive:       #${c.base03}ff;
      selected-fg:    #${c.base00}ff;
      font:           "${font}, Bold ${fontSize}";
    }

    window {
      transparency:     "real";
      location:         north;
      anchor:           north;
      padding:          ${gaps}px ${gaps}px 0;
      margin:           0;
      width:            100%;
      background-color: transparent;
      border:           0px;
    }

    mainbox {
      orientation:      horizontal;
      spacing:          0;
      padding:          6px 14px;
      border-radius:    100px;
      background-color: @background-alt;
      children:         [ "inputbar", "listview" ];
    }

    inputbar {
      expand:           false;
      spacing:          8px;
      padding:          0;
      background-color: transparent;
      color:            @foreground;
      children:         [ "prompt", "entry" ];
    }

    prompt {
      background-color: transparent;
      color:            @active;
      padding:          0 2px 0 0;
      vertical-align:   0.5;
    }

    entry {
      background-color:  transparent;
      color:             inherit;
      placeholder-color: @inactive;
      placeholder:       "Search...";
      vertical-align:    0.5;
      width:             180px;
    }

    listview {
      layout:           horizontal;
      lines:            1;
      dynamic:          true;
      scrollbar:        false;
      spacing:          0;
      padding:          0 0 0 14px;
      background-color: transparent;
      color:            @foreground;
    }

    element {
      enabled:          true;
      spacing:          0;
      padding:          2px 10px;
      border-radius:    100px;
      background-color: transparent;
      color:            @foreground;
      cursor:           pointer;
      children:         [ "element-text" ];
    }

    element selected.normal {
      background-color: @active;
      color:            @selected-fg;
    }

    element-text {
      background-color: transparent;
      color:            inherit;
      vertical-align:   0.5;
    }

    message {
      padding:          0;
      background-color: transparent;
      color:            @foreground;
    }

    error-message {
      padding:          10px;
      border-radius:    100px;
      background-color: @background-alt;
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
