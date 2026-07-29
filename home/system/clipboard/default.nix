# Clipboard history: cliphist watches the Wayland clipboard and stores every
# entry (text + images) so it can be recalled later via the `clipboard-menu`
# script (tofi). Uses the home-manager module so the watcher services are
# managed the same way as swaync/hypridle.
{...}: {
  services.cliphist = {
    enable = true;
    allowImages = true;
  };
}
