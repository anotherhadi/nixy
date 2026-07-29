{...}: {
  xdg.desktopEntries = {
    focus-toggle = {
      name = "Focus Mode";
      exec = "focus-toggle";
      icon = "do-not-disturb-symbolic";
      comment = "Toggle focus mode";
      categories = ["System"];
      terminal = false;
    };

    nightshift-toggle = {
      name = "Night Shift";
      exec = "nightshift-toggle";
      icon = "night-light-symbolic";
      comment = "Toggle night shift";
      categories = ["System"];
      terminal = false;
    };

    mic-mute = {
      name = "Mute Microphone";
      exec = "mic-mute";
      icon = "microphone-sensitivity-muted-symbolic";
      comment = "Toggle microphone mute";
      categories = ["System"];
      terminal = false;
    };

    lock = {
      name = "Lock";
      exec = "hyprlock";
      icon = "system-lock-screen-symbolic";
      comment = "Lock the screen";
      categories = ["System"];
      terminal = false;
    };

    reboot = {
      name = "Reboot";
      exec = "systemctl reboot";
      icon = "system-restart-symbolic";
      comment = "Restart the system";
      categories = ["System"];
      terminal = false;
    };

    shutdown = {
      name = "Shutdown";
      exec = "systemctl poweroff";
      icon = "system-shutdown-symbolic";
      comment = "Power off the system";
      categories = ["System"];
      terminal = false;
    };

    hibernate = {
      name = "Hibernate";
      exec = "systemctl hibernate";
      icon = "drive-harddisk-symbolic";
      comment = "Hibernate the system";
      categories = ["System"];
      terminal = false;
    };

    waybar-toggle = {
      name = "Toggle Waybar";
      exec = "waybar-toggle";
      icon = "panel-applets-symbolic";
      comment = "Show or hide the status bar";
      categories = ["System"];
      terminal = false;
    };

    wifi-toggle = {
      name = "Toggle Wi-Fi";
      exec = "wifi-toggle";
      icon = "network-wireless-symbolic";
      comment = "Enable or disable Wi-Fi";
      categories = ["System"];
      terminal = false;
    };

    bluetooth-toggle = {
      name = "Toggle Bluetooth";
      exec = "bluetooth-toggle";
      icon = "bluetooth-symbolic";
      comment = "Enable or disable Bluetooth";
      categories = ["System"];
      terminal = false;
    };

    color-pick = {
      name = "Pick Color";
      exec = "color-pick";
      icon = "color-select-symbolic";
      comment = "Pick a screen color to the clipboard";
      categories = ["Utility"];
      terminal = false;
      settings.Keywords = "color;picker;hex;eyedropper;";
    };

    screenshot-region = {
      name = "Screenshot Region";
      exec = "hyprshot -m region";
      icon = "screenshot-recorded-symbolic";
      comment = "Capture a selected region";
      categories = ["Utility"];
      terminal = false;
      settings.Keywords = "screenshot;capture;region;";
    };

    screenshot-window = {
      name = "Screenshot Window";
      exec = "hyprshot -m window";
      icon = "screenshot-recorded-symbolic";
      comment = "Capture the active window";
      categories = ["Utility"];
      terminal = false;
      settings.Keywords = "screenshot;capture;window;";
    };

    screenshot-screen = {
      name = "Screenshot Screen";
      exec = "hyprshot -m output";
      icon = "screenshot-recorded-symbolic";
      comment = "Capture the whole screen";
      categories = ["Utility"];
      terminal = false;
      settings.Keywords = "screenshot;capture;screen;monitor;";
    };

    screenshot-edit = {
      name = "Screenshot & Annotate";
      exec = "screenshot-edit";
      icon = "edit-symbolic";
      comment = "Capture a region and open it in Satty";
      categories = ["Utility"];
      terminal = false;
      settings.Keywords = "screenshot;annotate;satty;edit;";
    };

    record-toggle = {
      name = "Screen Recording";
      exec = "record-toggle";
      icon = "media-record-symbolic";
      comment = "Start or stop screen recording";
      categories = ["Utility" "AudioVideo"];
      terminal = false;
      settings.Keywords = "record;recording;screencast;video;";
    };

    power-cycle = {
      name = "Power Profile";
      exec = "power-cycle";
      icon = "power-profile-balanced-symbolic";
      comment = "Cycle power-saver / balanced / performance";
      categories = ["System"];
      terminal = false;
      settings.Keywords = "power;profile;performance;battery;";
    };

    airplane-toggle = {
      name = "Airplane Mode";
      exec = "airplane-toggle";
      icon = "airplane-mode-symbolic";
      comment = "Toggle Wi-Fi and Bluetooth together";
      categories = ["System"];
      terminal = false;
      settings.Keywords = "airplane;flight;wifi;bluetooth;offline;";
    };

    clipboard-menu = {
      name = "Clipboard History";
      exec = "clipboard-menu";
      icon = "edit-paste-symbolic";
      comment = "Pick a past clipboard entry";
      categories = ["Utility"];
      terminal = false;
      settings.Keywords = "clipboard;history;paste;cliphist;";
    };

    emoji-picker = {
      name = "Emoji Picker";
      exec = "emoji-picker";
      icon = "face-smile-symbolic";
      comment = "Pick an emoji and type it";
      categories = ["Utility"];
      terminal = false;
      settings.Keywords = "emoji;emoticon;smiley;symbol;";
    };

    caffeine-toggle = {
      name = "Keep Awake";
      exec = "caffeine-toggle";
      icon = "my-caffeine-on-symbolic";
      comment = "Pause or resume idle locking and suspend";
      categories = ["System"];
      terminal = false;
      settings.Keywords = "caffeine;idle;awake;inhibit;suspend;";
    };

    logout = {
      name = "Logout";
      exec = "hyprctl dispatch exit";
      icon = "system-log-out-symbolic";
      comment = "End the current session";
      categories = ["System"];
      terminal = false;
    };

    dnd-toggle = {
      name = "Do Not Disturb";
      exec = "dnd-toggle";
      icon = "notifications-disabled-symbolic";
      comment = "Toggle Do Not Disturb";
      categories = ["System"];
      terminal = false;
      settings.Keywords = "dnd;notifications;disturb;swaync;silence;";
    };

    vol-mute = {
      name = "Mute Volume";
      exec = "vol-mute";
      icon = "audio-volume-muted-symbolic";
      comment = "Toggle output mute";
      categories = ["System"];
      terminal = false;
    };

    vol-up = {
      name = "Volume Up";
      exec = "vol-up";
      icon = "audio-volume-high-symbolic";
      comment = "Raise the volume by 5%";
      categories = ["System"];
      terminal = false;
    };

    vol-down = {
      name = "Volume Down";
      exec = "vol-down";
      icon = "audio-volume-low-symbolic";
      comment = "Lower the volume by 5%";
      categories = ["System"];
      terminal = false;
    };

    bright-up = {
      name = "Brightness Up";
      exec = "bright-up";
      icon = "display-brightness-high-symbolic";
      comment = "Raise the brightness by 5%";
      categories = ["System"];
      terminal = false;
    };

    bright-down = {
      name = "Brightness Down";
      exec = "bright-down";
      icon = "display-brightness-low-symbolic";
      comment = "Lower the brightness by 5%";
      categories = ["System"];
      terminal = false;
    };

    output-cycle = {
      name = "Cycle Audio Output";
      exec = "output-cycle";
      icon = "audio-speakers-symbolic";
      comment = "Switch to the next audio output";
      categories = ["System"];
      terminal = false;
      settings.Keywords = "audio;output;sink;speaker;headphones;";
    };

    input-cycle = {
      name = "Cycle Audio Input";
      exec = "input-cycle";
      icon = "audio-input-microphone-symbolic";
      comment = "Switch to the next audio input";
      categories = ["System"];
      terminal = false;
      settings.Keywords = "audio;input;source;microphone;mic;";
    };

    spotatui = {
      name = "Spotify";
      exec = "ghostty -e spotatui";
      icon = "spotify";
      comment = "Control Spotify from the terminal";
      categories = ["Audio" "Music"];
      terminal = false;
      settings.Keywords = "spotify;spotatui;music;";
    };
  };
}
