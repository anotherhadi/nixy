{pkgs, ...}: {
  wayland.windowManager.hyprland.settings = {
    "$mod" = "SUPER";
    "$shiftMod" = "SUPER_SHIFT";

    bind =
      [
        "$mod,RETURN, exec, uwsm app -- ${pkgs.ghostty}/bin/ghostty" # Ghostty (terminal)
        "$mod,E, exec,  uwsm app -- ${pkgs.xfce.thunar}/bin/thunar" # Thunar
        "$mod,B, exec,  uwsm app -- ${pkgs.vivaldi}/bin/vivaldi" # Browser (Vivaldi)
        "$mod,K, exec,  uwsm app -- ${pkgs.proton-pass}/bin/proton-pass" # Proton Pass
        "$mod,V, exec,  uwsm app -- ${pkgs.protonvpn-gui}/bin/protonvpn-app" # Proton VPN
        "$mod,A, exec,  uwsm app -- env WEBKIT_DISABLE_COMPOSITING_MODE=1 ${pkgs.proton-authenticator}/bin/proton-authenticator" # Proton Auth
        "$mod,M, exec,  uwsm app -- ${pkgs.vivaldi}/bin/vivaldi --profile-directory=Default --app-id=jnpecgipniidlgicjocehkhajgdnjekh" # Proton Mail (PWA)
        "$mod,C, exec,  uwsm app -- ${pkgs.vivaldi}/bin/vivaldi --profile-directory=Default --app-id=ojibjkjikcpjonjjngfkegflhmffeemk" # Proton Calendar (PWA)
        "$mod,I, exec,  uwsm app -- ${pkgs.vivaldi}/bin/vivaldi --profile-directory=Default --app-id=lcfjlhjhpmdjimnbkdfjnkojodddgfmd" # Proton Lumo (PWA)

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
  };
}
