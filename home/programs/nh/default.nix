# NH reimplements some basic nix commands.
# Adding functionality on top of the existing solutions, like nixos-rebuild, home-manager cli or nix itself.
{ config, ... }: {
  programs.nh = {
    enable = true;
    flake = config.var.configDirectory;
    clean.enable = config.var.autoGarbageCollector;
    clean.extraArgs = "--keep-since 4d --keep 3";
  };
}
