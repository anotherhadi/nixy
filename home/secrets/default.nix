{ pkgs, config, homeage, ... }: {
  imports = [ homeage.homeManagerModules.homeage ];
  homeage = {
    identityPaths = [ "~/nixy.key" ];
    installationType = "activation";

    file."hadisecretkey" = {
      source = ./sshconfig.age;
      symlinks = [ "${config.home.homeDirectory}/.ssh/sshconfig" ];
    };
  };
}
