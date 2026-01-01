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
    inputs.eleakxir.packages.${stdenv.hostPlatform.system}.leak-utils
    caido
    nuclei
  ];
}
