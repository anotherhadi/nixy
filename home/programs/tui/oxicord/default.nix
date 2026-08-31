{
  pkgs,
  inputs,
  ...
}: let
  # Extract the package from the flake input
  oxicordPkg = inputs.oxicord.packages.${pkgs.system}.default;

  # Wrap the binary to dynamically inject the SOPS token at runtime
  oxicord-wrapped = pkgs.writeShellScriptBin "oxicord" ''
    export OXICORD_TOKEN=$(cat /run/secrets/discord-token)
    exec ${oxicordPkg}/bin/oxicord "$@"
  '';
in {
  home.packages = [oxicord-wrapped];

  # Oxicord honors the XDG Base Directory specification
  xdg.configFile."oxicord/config.toml".text = ''
    # Visual and behavioral configuration
    # See https://github.com/linuxmobile/oxicord for full options
  '';
}
