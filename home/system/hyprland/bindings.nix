{ pkgs, ... }: {
  wayland.windowManager.hyprland.settings = {
    bind = [
      "$mod,RETURN, exec, uwsm app -- ${pkgs.kitty}/bin/kitty" # Kitty
      "$mod,E, exec,  nautilus"
      "$mod,B, exec,  uwsm app -- firefox" # Browser
      "$mod,K, exec,  uwsm app -- ${pkgs.bitwarden}/bin/bitwarden" # Bitwarden
      "$mod,L, exec,  uwsm app -- ${pkgs.hyprlock}/bin/hyprlock" # Lock
      "$mod,X, exec, powermenu" # Powermenu
      "$mod,SPACE, exec, menu" # Launcher
      "$mod,C, exec, quickmenu" # Quickmenu
      "$mod,I, exec, ${../../scripts/swww/swww.sh} "
      "$shiftMod,SPACE, exec, hyprfocus-toggle" # Toggle HyprFocus
      "$mod,Y, exec, ${../../scripts/yazi/yazi.sh}"
      # "$mod,P, exec,  uwsm app -- ${pkgs.planify}/bin/io.github.alainm23.planify" # Planify
      "$mod, S, togglespecialworkspace, magic"
      "$mod SHIFT, S, movetoworkspace, special:magic"
      "$mod,Q, killactive," # Close window
      "$mod,W, togglefloating," # Toggle Floating
      "$mod,G, fullscreen" # Toggle Fullscreen
      "$mod,left, movefocus, l" # Move focus left
      "$mod,right, movefocus, r" # Move focus Right
      "$mod,up, movefocus, u" # Move focus Up
      "$mod,down, movefocus, d" # Move focus Down
      "$shiftMod,up, focusmonitor, -1" # Focus previous monitor
      "$shiftMod,down, focusmonitor, 1" # Focus next monitor
      "$shiftMod,left, layoutmsg, addmaster" # Add to master
      "$shiftMod,right, layoutmsg, removemaster" # Remove from master

      "$mod,P, exec, screenshot region" # Screenshot region
      "$shiftMod,P, exec, screenshot monitor" # Screenshot monitor
      "$shiftMod,O, exec, screenshot window" # Screenshot window
      "ALT,P, exec, screenshot region swappy" # Screenshot region then edit

      "$shiftMod,T, exec, hyprpanel-toggle" # Toggle hyprpanel
      "$shiftMod,C, exec, clipboard" # Clipboard picker with wofi
      "$shiftMod,E, exec, ${pkgs.wofi-emoji}/bin/wofi-emoji" # Emoji picker with wofi
      "$mod,F2, exec, night-shift" # Toggle night shift
      "$mod,F3, exec, night-shift" # Toggle night shift
    ] ++ (builtins.concatLists (builtins.genList (i:
      let ws = i + 1;
      in [
        "$mod,code:1${toString i}, workspace, ${toString ws}"
        "$mod SHIFT,code:1${toString i}, movetoworkspace, ${toString ws}"
      ]) 9));

    bindm = [
      "$mod,mouse:272, movewindow" # Move Window (mouse)
      "$mod,R, resizewindow" # Resize Window (mouse)
    ];

    bindl = [
      ",XF86AudioMute, exec, sound-toggle" # Toggle Mute
      ",XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl play-pause" # Play/Pause Song
      ",XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl next" # Next Song
      ",XF86AudioPrev, exec, ${pkgs.playerctl}/bin/playerctl previous" # Previous Song
      ",switch:Lid Switch, exec, ${pkgs.hyprlock}/bin/hyprlock" # Lock when closing Lid
    ];

    bindle = [
      ",XF86AudioRaiseVolume, exec, sound-up" # Sound Up
      ",XF86AudioLowerVolume, exec, sound-down" # Sound Down
      ",XF86MonBrightnessUp, exec, brightness-up" # Brightness Up
      ",XF86MonBrightnessDown, exec, brightness-down" # Brightness Down
    ];

  };
}
