# Sway keybindings, same as Hyprland's (modules/desktop/hyprland/bindings.nix)
{
  flake.modules.nixos.desktop.hjem.extraModules = [
    ({
      lib,
      pkgs,
      scripts,
      ...
    }: {
      sway.config = ''
        # Power
        bindsym $mod+x exec ${scripts.power-menu}/bin/power-menu

        # Quick launch
        bindsym $mod+Return exec ${pkgs.ghostty}/bin/ghostty +new-window
        bindsym $mod+e exec ${pkgs.ghostty}/bin/ghostty +new-window -e elio
        bindsym $mod+space exec ${scripts.tofi-drun-toggle}/bin/tofi-drun-toggle
        bindsym $mod+n exec ${pkgs.swaynotificationcenter}/bin/swaync-client -t

        # Windows
        bindsym $mod+q kill
        bindsym $mod+f fullscreen toggle
        bindsym $mod+Shift+f floating toggle
        # Left drag: move, right drag: resize
        floating_modifier $mod normal

        # Focus
        bindsym $mod+h focus left
        bindsym $mod+j focus down
        bindsym $mod+k focus up
        bindsym $mod+l focus right
        bindsym $mod+Shift+h focus output left
        bindsym $mod+Shift+l focus output right

        # Force the split of the next window (autotiling-rs picks it otherwise)
        bindsym $mod+Shift+j splitv
        bindsym $mod+Shift+k splith

        # Resize with hjkl, Escape/Return to leave
        mode "resize" {
          bindsym h resize shrink width 20px
          bindsym j resize grow height 20px
          bindsym k resize shrink height 20px
          bindsym l resize grow width 20px
          bindsym Return mode "default"
          bindsym Escape mode "default"
        }
        bindsym $mod+r mode "resize"

        # Scratchpad (Hyprland's special:scratch)
        bindsym $mod+s scratchpad show
        bindsym $mod+Shift+s move scratchpad

        # Workspaces, by keycode (layout independent, like Hyprland's code:1x)
        ${lib.concatMapStrings (i: let
          ws = toString (i + 1);
          code = toString (10 + i);
        in ''
          bindcode $mod+${code} workspace number ${ws}
          bindcode $mod+Shift+${code} move container to workspace number ${ws}
        '') (lib.range 0 8)}
        # Screenshots
        bindsym Print exec ${pkgs.sway-contrib.grimshot}/bin/grimshot --notify savecopy area
        bindsym $mod+Shift+Print exec ${pkgs.sway-contrib.grimshot}/bin/grimshot --notify savecopy output

        # Brightness (also when locked)
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
        bindsym --locked XF86AudioMicMute exec ${scripts.mic-mute}/bin/mic-mute
      '';
    })
  ];
}
