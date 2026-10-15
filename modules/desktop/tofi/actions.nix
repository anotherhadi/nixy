# Launcher entries for system actions (power, audio, network, screenshots, ...)
{
  flake.modules.nixos.desktop.hjem.extraModules = [
    ({
      pkgs,
      scripts,
      ...
    }: {
      packages = [
        (pkgs.makeDesktopItem {
          name = "mic-mute";
          desktopName = "Mute Microphone";
          exec = "${scripts.mic-mute}/bin/mic-mute";
          icon = "microphone-sensitivity-muted-symbolic";
          comment = "Toggle microphone mute";
          categories = ["System"];
          terminal = false;
        })
        (pkgs.makeDesktopItem {
          name = "reboot";
          desktopName = "Reboot";
          exec = "systemctl reboot";
          icon = "system-restart-symbolic";
          comment = "Restart the system";
          categories = ["System"];
          terminal = false;
        })
        (pkgs.makeDesktopItem {
          name = "suspend";
          desktopName = "Suspend";
          exec = "systemctl suspend";
          icon = "system-suspend-symbolic";
          comment = "Suspend the system";
          categories = ["System"];
          terminal = false;
        })
        (pkgs.makeDesktopItem {
          name = "shutdown";
          desktopName = "Shutdown";
          exec = "systemctl poweroff";
          icon = "system-shutdown-symbolic";
          comment = "Power off the system";
          categories = ["System"];
          terminal = false;
        })
        (pkgs.makeDesktopItem {
          name = "hibernate";
          desktopName = "Hibernate";
          exec = "systemctl hibernate";
          icon = "drive-harddisk-symbolic";
          comment = "Hibernate the system";
          categories = ["System"];
          terminal = false;
        })
        (pkgs.makeDesktopItem {
          name = "wifi-toggle";
          desktopName = "Toggle Wi-Fi";
          exec = "${scripts.wifi-toggle}/bin/wifi-toggle";
          icon = "network-wireless-symbolic";
          comment = "Enable or disable Wi-Fi";
          categories = ["System"];
          terminal = false;
        })
        (pkgs.makeDesktopItem {
          name = "bluetooth-toggle";
          desktopName = "Toggle Bluetooth";
          exec = "${scripts.bluetooth-toggle}/bin/bluetooth-toggle";
          icon = "bluetooth-symbolic";
          comment = "Enable or disable Bluetooth";
          categories = ["System"];
          terminal = false;
        })
        (pkgs.makeDesktopItem {
          name = "color-pick";
          desktopName = "Pick Color";
          exec = "${scripts.color-pick}/bin/color-pick";
          icon = "color-select-symbolic";
          comment = "Pick a screen color to the clipboard";
          categories = ["Utility"];
          terminal = false;
          keywords = ["color" "picker" "hex" "eyedropper"];
        })
        (pkgs.makeDesktopItem {
          name = "screenshot-region";
          desktopName = "Screenshot Region";
          exec = "${pkgs.hyprshot}/bin/hyprshot -m region";
          icon = "screenshot-recorded-symbolic";
          comment = "Capture a selected region";
          categories = ["Utility"];
          terminal = false;
          keywords = ["screenshot" "capture" "region"];
        })
        (pkgs.makeDesktopItem {
          name = "screenshot-window";
          desktopName = "Screenshot Window";
          exec = "${pkgs.hyprshot}/bin/hyprshot -m window";
          icon = "screenshot-recorded-symbolic";
          comment = "Capture the active window";
          categories = ["Utility"];
          terminal = false;
          keywords = ["screenshot" "capture" "window"];
        })
        (pkgs.makeDesktopItem {
          name = "screenshot-screen";
          desktopName = "Screenshot Screen";
          exec = "${pkgs.hyprshot}/bin/hyprshot -m output";
          icon = "screenshot-recorded-symbolic";
          comment = "Capture the whole screen";
          categories = ["Utility"];
          terminal = false;
          keywords = ["screenshot" "capture" "screen" "monitor"];
        })
        (pkgs.makeDesktopItem {
          name = "screenshot-edit";
          desktopName = "Screenshot & Annotate";
          exec = "${scripts.screenshot-edit}/bin/screenshot-edit";
          icon = "edit-symbolic";
          comment = "Capture a region and open it in Satty";
          categories = ["Utility"];
          terminal = false;
          keywords = ["screenshot" "annotate" "satty" "edit"];
        })
        (pkgs.makeDesktopItem {
          name = "record-toggle";
          desktopName = "Screen Recording";
          exec = "${scripts.record-toggle}/bin/record-toggle";
          icon = "media-record-symbolic";
          comment = "Start or stop screen recording";
          categories = ["Utility" "AudioVideo"];
          terminal = false;
          keywords = ["record" "recording" "screencast" "video"];
        })
        (pkgs.makeDesktopItem {
          name = "airplane-toggle";
          desktopName = "Airplane Mode";
          exec = "${scripts.airplane-toggle}/bin/airplane-toggle";
          icon = "airplane-mode-symbolic";
          comment = "Toggle Wi-Fi and Bluetooth together";
          categories = ["System"];
          terminal = false;
          keywords = ["airplane" "flight" "wifi" "bluetooth" "offline"];
        })
        (pkgs.makeDesktopItem {
          name = "emoji-picker";
          desktopName = "Emoji Picker";
          exec = "${scripts.emoji-picker}/bin/emoji-picker";
          icon = "face-smile-symbolic";
          comment = "Pick an emoji and type it";
          categories = ["Utility"];
          terminal = false;
          keywords = ["emoji" "emoticon" "smiley" "symbol"];
        })
        (pkgs.makeDesktopItem {
          name = "icon-picker";
          desktopName = "Icon Picker";
          exec = "${scripts.icon-picker}/bin/icon-picker";
          icon = "character-map-symbolic";
          comment = "Pick a Nerd Font icon and type it";
          categories = ["Utility"];
          terminal = false;
          keywords = ["icon" "nerdfont" "glyph" "symbol"];
        })
        (pkgs.makeDesktopItem {
          name = "logout";
          desktopName = "Logout";
          exec = "${pkgs.hyprland}/bin/hyprctl dispatch exit";
          icon = "system-log-out-symbolic";
          comment = "End the current session";
          categories = ["System"];
          terminal = false;
        })
        (pkgs.makeDesktopItem {
          name = "vol-mute";
          desktopName = "Mute Volume";
          exec = "${scripts.vol-mute}/bin/vol-mute";
          icon = "audio-volume-muted-symbolic";
          comment = "Toggle output mute";
          categories = ["System"];
          terminal = false;
        })
        (pkgs.makeDesktopItem {
          name = "vol-up";
          desktopName = "Volume Up";
          exec = "${scripts.vol-up}/bin/vol-up";
          icon = "audio-volume-high-symbolic";
          comment = "Raise the volume by 5%";
          categories = ["System"];
          terminal = false;
        })
        (pkgs.makeDesktopItem {
          name = "vol-down";
          desktopName = "Volume Down";
          exec = "${scripts.vol-down}/bin/vol-down";
          icon = "audio-volume-low-symbolic";
          comment = "Lower the volume by 5%";
          categories = ["System"];
          terminal = false;
        })
        (pkgs.makeDesktopItem {
          name = "bright-up";
          desktopName = "Brightness Up";
          exec = "${scripts.bright-up}/bin/bright-up";
          icon = "display-brightness-high-symbolic";
          comment = "Raise the brightness by 5%";
          categories = ["System"];
          terminal = false;
        })
        (pkgs.makeDesktopItem {
          name = "bright-down";
          desktopName = "Brightness Down";
          exec = "${scripts.bright-down}/bin/bright-down";
          icon = "display-brightness-low-symbolic";
          comment = "Lower the brightness by 5%";
          categories = ["System"];
          terminal = false;
        })
        (pkgs.makeDesktopItem {
          name = "output-cycle";
          desktopName = "Cycle Audio Output";
          exec = "${scripts.output-cycle}/bin/output-cycle";
          icon = "audio-speakers-symbolic";
          comment = "Switch to the next audio output";
          categories = ["System"];
          terminal = false;
          keywords = ["audio" "output" "sink" "speaker" "headphones"];
        })
        (pkgs.makeDesktopItem {
          name = "input-cycle";
          desktopName = "Cycle Audio Input";
          exec = "${scripts.input-cycle}/bin/input-cycle";
          icon = "audio-input-microphone-symbolic";
          comment = "Switch to the next audio input";
          categories = ["System"];
          terminal = false;
          keywords = ["audio" "input" "source" "microphone" "mic"];
        })
        (pkgs.makeDesktopItem {
          name = "settuings";
          desktopName = "Settings";
          exec = "${pkgs.ghostty}/bin/ghostty +new-window -e ${pkgs.nur.repos.anotherhadi.settuings}/bin/settuings";
          icon = "preferences-system-symbolic";
          comment = "Terminal based settings (wifi, bluetooth, audio, ...)";
          categories = ["Settings"];
          terminal = false;
          keywords = ["settings" "wifi" "bluetooth" "audio" "settuings"];
        })
      ];
    })
  ];
}
