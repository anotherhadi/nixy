{
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    firefox
    wireshark
    nmap
    john
    hashcat
    inputs.eleakxir.packages.${stdenv.hostPlatform.system}.leak-utils
    caido
    nuclei
  ];
}
