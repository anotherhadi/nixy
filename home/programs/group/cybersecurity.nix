{pkgs, ...}: {
  home.packages = with pkgs; [
    wireshark
    nmap
  ];
}
