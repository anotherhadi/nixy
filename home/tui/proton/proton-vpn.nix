{pkgs, ...}: {
  # TODO: config + desktop file
  home.packages = [
    pkgs.nur.repos.anotherhadi.proton-vpn-tui
    pkgs.proton-vpn-cli
  ];
}
