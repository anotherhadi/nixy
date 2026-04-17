{
  pkgs-stable,
  inputs,
  ...
}: {
  home.packages = with pkgs-stable; [
    wireshark
    nmap
    john
    hashcat

    # Web
    caido
    nuclei
    gobuster
    dirb

    # Utils
    inetutils
    samba
    openvpn
    mariadb
    redis
  ];
}
