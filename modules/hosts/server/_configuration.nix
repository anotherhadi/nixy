{config, ...}: {
  imports = [
    # You should let those lines as is
    ./_hardware-configuration.nix

    ./_secrets
  ];

  hjem.users.${config.nixy.username}.enable = true;

  # Don't touch this
  system.stateVersion = "26.05";
}
