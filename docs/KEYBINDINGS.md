# Keybindings

The list of the keybindings working on Hyprland:

| Description | Keybinding | Command |
| -- | -- | -- |
| Switch Workspace | SUPER + {Number} | workspace {Number} |
| Move app to Workspace | SUPER SHIFT + {Number} | movetoworkspace {Number} |
|  Kitty | SUPER +  RETURN |  exec  ${pkgs.kitty}/bin/kitty |
|  Thunar | SUPER +  E |  exec  ${pkgs.xfce.thunar}/bin/thunar |
|  Qutebrowser | SUPER +  B |  exec  ${pkgs.qutebrowser}/bin/qutebrowser |
|  Bitwarden | SUPER +  K |  exec  ${pkgs.bitwarden}/bin/bitwarden |
|  Peaclock | SUPER +  C |  exec  ${pkgs.kitty}/bin/kitty --class peaclock peaclock |
|  Lock | SUPER +  L |  exec  ${pkgs.hyprlock}/bin/hyprlock |
|  Powermenu | SUPER +  X |  exec  powermenu |
|  Launcher | SUPER +  SPACE |  exec  menu |
|  Close window | SUPER +  Q |  killactive  |
|  Toggle Floating | SUPER +  T |  togglefloating  |
|  Toggle Fullscreen | SUPER +  F |  fullscreen  |
|  Move focus left | SUPER +  left |  movefocus  l |
|  Move focus Right | SUPER +  right |  movefocus  r |
|  Move focus Up | SUPER +  up |  movefocus  u |
|  Move focus Down | SUPER +  down |  movefocus  d |
|  Screenshot window | SUPER +  PRINT |  exec  screenshot window |
|  Screenshot monitor |  PRINT |  exec  screenshot monitor |
|  Screenshot region | SUPER SHIFT +  PRINT |  exec  screenshot region |
|  Screenshot region then edit | ALT PRINT |  exec  screenshot region swappy |
|  Turn off night shift | SUPER +  F2 |  exec  night-shift-off |
|  Turn on night shift | SUPER +  F3 |  exec  night-shift-on |
|  Choose sound output | SUPER +  F5 |  exec  ${pkgs.kitty}/bin/kitty --class floating zsh -c sound-output |
|  Move Window (mouse) | SUPER +  mouse:272 |  movewindow  |
|  Resize Window (mouse) | SUPER +  R |  resizewindow  |
|  Toggle Mute | XF86AudioMute |  exec  sound-toggle |
|  Lock when closing Lid | switch:Lid Switch |  exec  ${pkgs.hyprlock}/bin/hyprlock |
|  Sound Up |  XF86AudioRaiseVolume |  exec  sound-up |
|  Sound Down |  XF86AudioLowerVolume |  exec  sound-down |
|  Brightness Up |  XF86MonBrightnessUp |  exec  brightness-up |
|  Brightness Down |  XF86MonBrightnessDown |  exec  brightness-down |
