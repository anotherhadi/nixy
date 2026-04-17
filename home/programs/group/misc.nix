{pkgs, ...}: {
  home.packages = with pkgs; [
    peaclock
    cbonsai
    pipes
    cmatrix
    fastfetch
  ];
}
