{
  pkgs,
  pkgs-stable,
  pkgs-nur-hadi,
}:
(with pkgs-stable; [
  # Web
  dirb
  ffuf
  katana
  whatweb

  # Hashes
  hashcat
  haiti
  hydra
  john

  # Databases
  mariadb
  redis
  sqlmap
  nosqli

  # Network
  inetutils
  termshark # wireshark in TUI
  dnsrecon
  whois
  dig
  nmap
  samba

  # Misc
  metasploit
  nuclei
  openvpn

  # Secrets
  trufflehog

  # Forensics
  binwalk
])
++ (with pkgs-nur-hadi; [
  spilltea
  jwt-tui
])
