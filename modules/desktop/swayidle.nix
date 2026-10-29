# swayidle handles idle management: lock the screen, turn the display off, and
# suspend after periods of inactivity. `caffeine-toggle` pauses it.
{
  flake.modules.nixos.desktop.hjem.extraModules = [
    ({
      pkgs,
      scripts,
      ...
    }: {
      # Screen on/off
      scripts.dpms = pkgs.writeShellScript "dpms" ''
        ${pkgs.sway}/bin/swaymsg "output * power $1"
        [ "$1" = on ] && ${pkgs.kanshi}/bin/kanshictl reload 2>/dev/null
        true
      '';

      xdg.config.files."swayidle/config".text = ''
        timeout 300 '${scripts.lock}/bin/lock --grace 5 &'
        timeout 720 '${scripts.dpms} off' resume '${scripts.dpms} on'
        timeout 1800 'systemctl suspend'
        before-sleep '${scripts.lock}/bin/lock & sleep 1'
        after-resume '${scripts.dpms} on'
        lock '${scripts.lock}/bin/lock &'
      '';

      systemd.services.swayidle = {
        description = "swayidle idle manager";
        after = ["graphical-session.target"];
        partOf = ["graphical-session.target"];
        wantedBy = ["graphical-session.target"];
        serviceConfig = {
          ExecStart = "${pkgs.swayidle}/bin/swayidle -w";
          Restart = "on-failure";
        };
      };
    })
  ];
}
