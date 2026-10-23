# Podman: rootless, daemonless containers (`docker` is an alias to podman)
{
  flake.modules.nixos.podman = {pkgs, ...}: {
    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true; # Containers reach each other by name
    };

    # lazydocker talks to the user API socket (enabled by the podman module)
    environment.systemPackages = [
      (pkgs.writeShellScriptBin "lazydocker" ''
        export DOCKER_HOST="unix://$XDG_RUNTIME_DIR/podman/podman.sock"
        exec ${pkgs.lazydocker}/bin/lazydocker "$@"
      '')
    ];
  };
}
