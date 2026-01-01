{
  wayland.windowManager.hyprland.settings = {
    bindin = [
      # Launcher
      "$mod, mouse:272, global, caelestia:launcherInterrupt"
      "$mod, mouse:273, global, caelestia:launcherInterrupt"
      "$mod, mouse:274, global, caelestia:launcherInterrupt"
      "$mod, mouse:275, global, caelestia:launcherInterrupt"
      "$mod, mouse:276, global, caelestia:launcherInterrupt"
      "$mod, mouse:277, global, caelestia:launcherInterrupt"
      "$mod, mouse_up, global, caelestia:launcherInterrupt"
      "$mod, mouse_down, global, caelestia:launcherInterrupt"
    ];
    bind = [
      # Launcher
      "$mod, SPACE, global, caelestia:launcher"
      "$mod, X, global, caelestia:session" # Powermenu

      # Misc
      "$mod, L, global, caelestia:lock"
      "$mod, N, exec, caelestia shell drawers toggle sidebar"

      # Utilities
      "$mod+Shift, SPACE, exec, caelestia shell gameMode toggle" # Toggle Focus/Game mode
      "$mod+Shift, S, global, caelestia:screenshotFreeze" # Capture region (freeze)
      "$mod+Shift+Alt, S, global, caelestia:screenshot" # Capture region
      "$mod+Alt, R, exec, caelestia record -s" # Record screen with sound
      "Ctrl+Alt, R, exec, caelestia record" # Record screen
      "$mod+Shift+Alt, R, exec, caelestia record -r" # Record region

      "$mod+Shift, E, exec, pkill fuzzel || caelestia emoji -p"
    ];
    bindl = [
      # Brightness
      ", XF86MonBrightnessUp, global, caelestia:brightnessUp"
      ", XF86MonBrightnessDown, global, caelestia:brightnessDown"
      "$mod, F2, exec, nightshift-toggle"
      "$mod, F3, exec, nightshift-toggle"

      # Media
      ", XF86AudioPlay, global, caelestia:mediaToggle"
      ", XF86AudioPause, global, caelestia:mediaToggle"
      ", XF86AudioNext, global, caelestia:mediaNext"
      ", XF86AudioPrev, global, caelestia:mediaPrev"
      ", XF86AudioStop, global, caelestia:mediaStop"

      # Sound
      ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"

      # Utilities
      ", Print, exec, caelestia screenshot" # Full screen capture > clipboard
    ];
    bindle = [
      ", XF86AudioRaiseVolume, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
      ", XF86AudioLowerVolume, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
    ];
  };
}
