{pkgs-stable, ...}: {
  home.packages = with pkgs-stable; [
    tty-solitaire
    bastet
    peaclock
    cbonsai
    pipes
    cmatrix
    fastfetch
  ];
}
