{pkgs, ...}: {
  wayland.windowManager.hyprland.settings = {
    bind =
      [
        "$mod,RETURN, exec, uwsm app -- ${pkgs.kitty}/bin/kitty" # Kitty
        "$mod,E, exec,  uwsm app -- ${pkgs.xfce.thunar}/bin/thunar" # Thunar
        "$mod,B, exec,  uwsm app -- ${pkgs.brave}/bin/brave" # Brave Browser
        "$mod,K, exec,  uwsm app -- ${pkgs.proton-pass}/bin/proton-pass" # Proton Pass
        "$mod,M, exec,  uwsm app -- ${pkgs.protonmail-desktop}/bin/proton-mail" # Proton Mail
        "$mod,V, exec,  uwsm app -- ${pkgs.protonvpn-gui}/bin/protonvpn-app" # Proton VPN
        "$mod,A, exec,  uwsm app -- ${pkgs.proton-authenticator}/bin/proton-authenticator" # Proton Authenticator
        "$mod,L, exec,  uwsm app -- ${pkgs.hyprlock}/bin/hyprlock" # Lock
        "$mod,X, exec, powermenu" # Powermenu
        "$mod,SPACE, exec, vicinae" # Launcher
        "$shiftMod,SPACE, exec, hyprfocus-toggle" # Toggle HyprFocus

        "$mod,Q, killactive," # Close window
        "$mod,T, togglefloating," # Toggle Floating
        "$mod,F, fullscreen" # Toggle Fullscreen
        "$mod,left, movefocus, l" # Move focus left
        "$mod,right, movefocus, r" # Move focus Right
        "$mod,up, movefocus, u" # Move focus Up
        "$mod,down, movefocus, d" # Move focus Down
        "$shiftMod,up, focusmonitor, -1" # Focus previous monitor
        "$shiftMod,down, focusmonitor, 1" # Focus next monitor
        "$shiftMod,left, layoutmsg, addmaster" # Add to master
        "$shiftMod,right, layoutmsg, removemaster" # Remove from master

        "$mod,PRINT, exec, screenshot region" # Screenshot region
        ",PRINT, exec, screenshot monitor" # Screenshot monitor
        "$shiftMod,PRINT, exec, screenshot window" # Screenshot window
        "ALT,PRINT, exec, screenshot region swappy" # Screenshot region then edit

        "$shiftMod,T, exec, hyprpanel-toggle" # Toggle hyprpanel
        "$shiftMod,C, exec, clipboard" # Clipboard picker with wofi
        "$shiftMod,E, exec, ${pkgs.wofi-emoji}/bin/wofi-emoji" # Emoji picker with wofi
        "$shiftMod,F2, exec, night-shift" # Toggle night shift
        "$shiftMod,F3, exec, night-shift" # Toggle night shift
      ]
      ++ (builtins.concatLists (builtins.genList (i: let
          ws = i + 1;
        in [
          "$mod,code:1${toString i}, workspace, ${toString ws}"
          "$mod SHIFT,code:1${toString i}, movetoworkspace, ${toString ws}"
        ])
        9));

    bindm = [
      "$mod,mouse:272, movewindow" # Move Window (mouse)
      "$mod,R, resizewindow" # Resize Window (mouse)
    ];

    bindl = [
      ",switch:Lid Switch, exec, ${pkgs.hyprlock}/bin/hyprlock" # Lock when closing Lid
    ];
  };
}
