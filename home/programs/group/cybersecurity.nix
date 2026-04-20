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
    ffuf
    sqlmap

    # Utils
    inetutils
    samba
    openvpn
    mariadb
    redis
  ];
}
