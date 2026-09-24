{pkgs, ...}: {
  services.protonmail-bridge = {
    enable = true;
    path = with pkgs; [gnome-keyring];
  };

  # TODO: github:ssp-data/Neomd
  # + desktop files
}
