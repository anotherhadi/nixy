{pkgs-stable, ...}: {
  home.packages = with pkgs-stable; [
    peaclock
    cbonsai
    pipes
    cmatrix
    fastfetch
  ];
}
