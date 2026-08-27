{pkgs}: (with pkgs; [
  # Web
  pkgs.nur.repos.anotherhadi.spilltea
  dirb
  ffuf
  katana
  whatweb
  sqlmap
  nosqli

  # Hashes
  hashcat
  haiti
  john

  # Databases
  mariadb
  redis

  # Network
  termshark # wireshark in TUI
  wtfis # Passive hostname, domain and IP lookup tool
  inetutils
  whois
  dig
  nmap
  samba
  hydra
  pkgs.nur.repos.anotherhadi.revshell

  # Misc
  metasploit
  nuclei
  openvpn
  zizmor # CI/CD Pipelines
  trufflehog # Look for secrets
  pkgs.nur.repos.anotherhadi.jwt-tui
  pkgs.nur.repos.anotherhadi.default-creds-tui

  # Forensics
  binwalk
])
