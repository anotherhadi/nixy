# Sway keybindings
{
  flake.modules.nixos.desktop.hjem.extraModules = [
    ({
      lib,
      pkgs,
      scripts,
      ...
    }: {
      sway.config = ''
        # $mod+x twice locks
        set $power "power: [l]ock [s]uspend [r]eboot [p]oweroff"
        mode $power {
          bindsym l exec ${scripts.lock}/bin/lock, mode "default"
          bindsym s exec systemctl suspend, mode "default"
          bindsym r exec systemctl reboot, mode "default"
          bindsym p exec systemctl poweroff, mode "default"
          bindsym Escape mode "default"
          bindsym Ctrl+c mode "default"
          bindsym $mod+x exec ${scripts.lock}/bin/lock, mode "default"
        }
        bindsym $mod+x mode $power

        # Quick launch
        bindsym $mod+Return exec ${scripts.term}/bin/term
        bindsym $mod+e exec ${scripts.term}/bin/term elio
        bindsym $mod+space exec ${scripts.tofi-drun-toggle}/bin/tofi-drun-toggle
        bindsym $mod+n exec ${pkgs.swaynotificationcenter}/bin/swaync-client -t

        # Windows
        bindsym $mod+q kill
        bindsym $mod+f fullscreen toggle
        bindsym $mod+Shift+f floating toggle
        bindsym $mod+Shift+space exec ${scripts.focus-toggle}/bin/focus-toggle
        floating_modifier $mod normal
        tiling_drag disable

        # Focus
        bindsym $mod+h focus left
        bindsym $mod+j focus down
        bindsym $mod+k focus up
        bindsym $mod+l focus right
        bindsym $mod+Shift+h focus output left
        bindsym $mod+Shift+l focus output right

        # Resize with hjkl, Escape/Return/Ctrl+c/$mod+r to leave
        mode "resize" {
          bindsym h resize shrink width 20px
          bindsym j resize grow height 20px
          bindsym k resize shrink height 20px
          bindsym l resize grow width 20px
          bindsym Return mode "default"
          bindsym Escape mode "default"
          bindsym Ctrl+c mode "default"
          bindsym $mod+r mode "default"
        }
        bindsym $mod+r mode "resize"

        # Scratch workspace
        bindsym $mod+s exec ${scripts.scratch-toggle}/bin/scratch-toggle
        bindsym $mod+Shift+s move container to workspace scratch

        # Workspaces, by keycode (layout independent)
        ${lib.concatMapStrings (i: let
          ws = toString (i + 1);
          code = toString (10 + i);
        in ''
          bindcode $mod+${code} workspace number ${ws}
          bindcode $mod+Shift+${code} move container to workspace number ${ws}
        '') (lib.range 0 8)}

        # Screenshots
        bindsym Print exec ${pkgs.sway-contrib.grimshot}/bin/grimshot --notify savecopy anything
        bindsym $mod+Print exec ${scripts.record-toggle}/bin/record-toggle

        # Brightness
        bindsym --locked XF86MonBrightnessUp exec ${scripts.bright-up}/bin/bright-up
        bindsym --locked XF86MonBrightnessDown exec ${scripts.bright-down}/bin/bright-down

        # Media
        bindsym --locked XF86AudioPlay exec ${pkgs.playerctl}/bin/playerctl play-pause
        bindsym --locked XF86AudioPause exec ${pkgs.playerctl}/bin/playerctl play-pause
        bindsym --locked XF86AudioNext exec ${pkgs.playerctl}/bin/playerctl next
        bindsym --locked XF86AudioPrev exec ${pkgs.playerctl}/bin/playerctl previous
        bindsym --locked XF86AudioStop exec ${pkgs.playerctl}/bin/playerctl stop

        # Sound
        bindsym --locked XF86AudioMute exec ${scripts.vol-mute}/bin/vol-mute
        bindsym --locked XF86AudioRaiseVolume exec ${scripts.vol-up}/bin/vol-up
        bindsym --locked XF86AudioLowerVolume exec ${scripts.vol-down}/bin/vol-down
        bindsym XF86AudioMicMute exec ${scripts.mic-mute}/bin/mic-mute
      '';
    })
  ];
}
