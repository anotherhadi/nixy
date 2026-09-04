{
  config,
  pkgs,
  ...
}: let
  b = config.stylix.base16Scheme;
  hex = shade: "#${shade}";
  rgbTriplet = shade: let
    d = c:
      if c == "a"
      then 10
      else if c == "b"
      then 11
      else if c == "c"
      then 12
      else if c == "d"
      then 13
      else if c == "e"
      then 14
      else if c == "f"
      then 15
      else pkgs.lib.toInt c;
    h = pkgs.lib.toLower shade;
    byte = pos: toString (d (builtins.substring pos 1 h) * 16 + d (builtins.substring (pos + 1) 1 h));
  in "${byte 0}, ${byte 2}, ${byte 4}";
in {
  "Nixy" = {
    # Main interface colors
    "primary-color" = hex b.base0D;
    "accent-color" = "var(--primary-color)";
    "primary-background-color" = hex b.base00;
    "secondary-background-color" = hex b.base01;
    "divider-color" = hex b.base02;
    # Text
    "primary-text-color" = hex b.base05;
    "text-primary-color" = "var(--primary-text-color)";
    "secondary-text-color" = hex b.base04;
    "disabled-text-color" = hex b.base03;
    # Header / sidebar
    "app-header-background-color" = hex b.base01;
    "app-header-text-color" = "var(--primary-text-color)";
    "app-header-selection-bar-color" = "var(--primary-color)";
    "app-header-edit-background-color" = hex b.base02;
    "sidebar-icon-color" = "var(--secondary-text-color)";
    "sidebar-text-color" = "var(--primary-text-color)";
    "sidebar-background-color" = hex b.base01;
    "sidebar-selected-icon-color" = "var(--primary-color)";
    "sidebar-selected-text-color" = "var(--primary-color)";
    # Buttons / icons / state
    "paper-item-icon-color" = "var(--secondary-text-color)";
    "paper-item-icon-active-color" = "var(--primary-color)";
    "mdc-button-outline-color" = "var(--primary-color)";
    "state-icon-color" = "var(--paper-item-icon-color)";
    "state-icon-active-color" = "var(--paper-item-icon-active-color)";
    "state-icon-unavailable-color" = "var(--disabled-text-color)";
    # Sliders
    "paper-slider-knob-color" = "var(--primary-color)";
    "paper-slider-knob-start-color" = "var(--primary-color)";
    "paper-slider-pin-color" = "var(--primary-color)";
    "paper-slider-active-color" = "var(--primary-color)";
    "paper-slider-secondary-color" = "var(--secondary-background-color)";
    # Labels / badges
    "label-badge-background-color" = "var(--secondary-background-color)";
    "label-badge-text-color" = "var(--primary-text-color)";
    "label-badge-red" = hex b.base08;
    "label-badge-green" = hex b.base0B;
    "label-badge-blue" = hex b.base0D;
    "label-badge-yellow" = hex b.base0A;
    "label-badge-gray" = "var(--secondary-text-color)";
    # Cards / surfaces
    "card-background-color" = hex b.base01;
    "ha-card-background" = "var(--card-background-color)";
    "ha-card-border-color" = hex b.base02;
    "paper-dialog-background-color" = "var(--card-background-color)";
    "paper-listbox-background-color" = "var(--card-background-color)";
    "paper-card-background-color" = "var(--card-background-color)";
    "table-row-background-color" = "var(--primary-background-color)";
    "table-row-alternative-background-color" = "var(--secondary-background-color)";
    "data-table-background-color" = "var(--primary-background-color)";
    "material-background-color" = "var(--primary-background-color)";
    "material-secondary-background-color" = "var(--secondary-background-color)";
    "markdown-code-background-color" = hex b.base01;
    "code-editor-background-color" = hex b.base01;
    # Switches / toggles
    "switch-checked-button-color" = "var(--primary-color)";
    "switch-checked-track-color" = "var(--primary-color)";
    "switch-unchecked-button-color" = "var(--secondary-text-color)";
    "switch-unchecked-track-color" = "var(--disabled-text-color)";
    "paper-toggle-button-checked-button-color" = "var(--switch-checked-button-color)";
    "paper-toggle-button-checked-bar-color" = "var(--switch-checked-track-color)";
    "paper-toggle-button-unchecked-button-color" = "var(--switch-unchecked-button-color)";
    "paper-toggle-button-unchecked-bar-color" = "var(--switch-unchecked-track-color)";
    "mdc-checkbox-unchecked-color" = "var(--secondary-text-color)";
    "mdc-checkbox-disable-color" = "var(--disabled-text-color)";
    "mdc-theme-primary" = "var(--primary-color)";
    "mdc-theme-secondary" = "var(--primary-color)";
    "mdc-theme-background" = "var(--primary-background-color)";
    "mdc-theme-surface" = "var(--card-background-color)";
    "mdc-theme-on-primary" = hex b.base00;
    "mdc-theme-on-secondary" = hex b.base00;
    "mdc-theme-on-surface" = "var(--primary-text-color)";
    "mdc-theme-text-primary-on-background" = "var(--primary-text-color)";
    "mdc-theme-text-secondary-on-background" = "var(--secondary-text-color)";
    "mdc-theme-text-hint-on-background" = "var(--secondary-text-color)";
    "mdc-theme-text-disabled-on-background" = "var(--disabled-text-color)";
    "mdc-theme-text-icon-on-background" = "var(--secondary-text-color)";
    "mdc-select-fill-color" = "var(--secondary-background-color)";
    "mdc-select-ink-color" = "var(--primary-text-color)";
    "mdc-select-label-ink-color" = "var(--secondary-text-color)";
    "mdc-select-idle-line-color" = "var(--secondary-text-color)";
    "mdc-select-dropdown-icon-color" = "var(--secondary-text-color)";
    "mdc-select-hover-line-color" = "var(--primary-color)";
    "mdc-list-item-graphic-color" = "var(--secondary-text-color)";
    "mdc-text-field-fill-color" = "var(--mdc-select-fill-color)";
    "mdc-text-field-ink-color" = "var(--primary-text-color)";
    "mdc-text-field-label-ink-color" = "var(--secondary-text-color)";
    "mdc-text-field-idle-line-color" = "var(--secondary-text-color)";
    "input-fill-color" = "var(--secondary-background-color)";
    "input-dropdown-icon-color" = "var(--secondary-text-color)";
    "input-ink-color" = "var(--primary-text-color)";
    "input-label-ink-color" = "var(--secondary-text-color)";
    "input-idle-line-color" = "var(--secondary-text-color)";
    "input-hover-line-color" = "var(--primary-color)";
    "rgb-primary-text-color" = rgbTriplet b.base05;
    "rgb-primary-color" = rgbTriplet b.base0D;
    "rgb-accent-color" = rgbTriplet b.base0D;
  };
}
