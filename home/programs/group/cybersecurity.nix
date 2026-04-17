{
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    wireshark
    nmap
    john
    hashcat
    # inputs.eleakxir.packages.${stdenv.hostPlatform.system}.leak-utils

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
