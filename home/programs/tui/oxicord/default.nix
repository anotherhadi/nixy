{
  pkgs,
  inputs,
  ...
}: let
  patchedOxicord = inputs.oxicord.packages.${pkgs.system}.default.overrideAttrs (finalAttrs: previousAttrs: {
    doCheck = false;
    postPatch =
      (previousAttrs.postPatch or "")
      + ''
         # Resolve the E0061 compilation error caused by a missing 'ratatui::prelude::Style' argument.
        substituteInPlace src/presentation/services/markdown_renderer.rs \
          --replace-fail "renderer.render(blocks, None, false);" \
                         "renderer.render(blocks, None, false, ratatui::prelude::Style::default());"
      '';
  });

  # 2. Create a wrapper script to inject the SOPS token at runtime
  oxicordWrapped = pkgs.symlinkJoin {
    name = "oxicord";
    paths = [patchedOxicord];
    buildInputs = [pkgs.makeWrapper];
    postBuild = ''
      wrapProgram $out/bin/oxicord \
        --run 'if [ -f /run/secrets/discord-token ]; then export OXICORD_TOKEN=$(cat /run/secrets/discord-token); else echo "WARNING: SOPS secret not found at /run/secrets/discord-token"; fi'
    '';
  };
in {
  # 3. Add the wrapped binary and tmux to your user packages
  home.packages = [
    oxicordWrapped
    pkgs.tmux
  ];

  # 4. Set up an alias to quickly attach to the background session
  programs.zsh.shellAliases = {
    discord = "tmux attach -t oxicord";
  };

  # 5. Create the systemd service to run it in the background
  systemd.user.services.oxicord = {
    Unit = {
      Description = "Oxicord Background Session";
      After = ["graphical-session.target"];
      PartOf = ["graphical-session.target"];
    };
    Install = {
      WantedBy = ["graphical-session.target"];
    };
    Service = {
      Type = "forking";
      # Hardcode D-Bus address to ensure desktop notifications reach SwayNC
      Environment = "DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/%U/bus";
      ExecStart = "${pkgs.tmux}/bin/tmux new-session -d -s oxicord '${oxicordWrapped}/bin/oxicord'";
      ExecStop = "${pkgs.tmux}/bin/tmux kill-session -t oxicord";
      Restart = "on-failure";
    };
  };
}
