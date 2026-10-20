{pkgs, ...}: (with pkgs; [
  # Web
  pkgs.nur.repos.anotherhadi.spilltea
  dirb
  ffuf
  kiterunner
  sqlmap
  nosqli
  pkgs.unstable.uro
  pkgs.unstable.katana
  pkgs.unstable.whatweb
  pkgs.unstable.httpx
  pkgs.unstable.dnsx
  pkgs.unstable.shuffledns
  pkgs.unstable.subfinder
  pkgs.unstable.urlfinder
  pkgs.unstable.cdncheck
  pkgs.unstable.naabu
  pkgs.unstable.alterx
  massdns

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

  # Reverse
  binsider # Analyzer of executables using a terminal user interface

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
