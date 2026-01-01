{
  programs.caelestia.settings.bar = {
    clock.showIcon = false;
    popouts.activeWindow = false;
    persistent = true;
    status = {
      showBattery = true;
      showMicrophone = false;
      showLockStatus = false;
      showBluetooth = true;
      showAudio = true;
      showKbLayout = false;
      showNetwork = true;
    };
    workspaces = {
      activeIndicator = true;
      activeLabel = "󰪥 ";
      activeTrail = false;
      label = " ";
      occupiedBg = true;
      occupiedLabel = "󰪥 ";
      rounded = true;
      showWindows = false;
      shown = 5;
    };
    entries = [
      {
        id = "logo";
        enabled = true;
      }
      {
        id = "workspaces";
        enabled = true;
      }
      {
        id = "spacer";
        enabled = true;
      }
      {
        id = "activeWindow";
        enabled = true;
      }
      {
        id = "spacer";
        enabled = true;
      }
      {
        id = "tray";
        enabled = true;
      }
      {
        id = "clock";
        enabled = true;
      }
      {
        id = "statusIcons";
        enabled = true;
      }
      {
        id = "power";
        enabled = true;
      }
    ];
    tray = {
      background = false;
      recolour = false;
    };
  };
}
