{
  pkgs-stable,
  inputs,
  ...
}: {
  home.packages = with pkgs-stable; [
    tty-solitaire
    bastet
    peaclock
    cbonsai
    pipes
    cmatrix
    fastfetch
    inputs.usbguard-tui.packages.${pkgs-stable.stdenv.hostPlatform.system}.default
  ];
}
