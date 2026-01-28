{
  config,
  lib,
  pkgs,
  ...
}: {
  systemd.user.services.replays = {
    description = "GPU Screen Recorder Replays";
    after = ["graphical-session.target"];
    wantedBy = ["graphical-session.target"];
    serviceConfig = {
      Type = "simple";
      Restart = "always";
      ExecStart = ''
        ${pkgs.gpu-screen-recorder}/bin/gpu-screen-recorder -w DP-1 -q ultra -a default_output -a default_input -f 60 -r 300 -c mp4 -o %h/Games/Replays
      '';
    };
  };
}
