{
  pkgs,
  pkgs-stable,
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
++ [ pkgs.dnsrecon ]
++ (with pkgs.nur.repos.anotherhadi; [
  spilltea
  jwt-tui
])
