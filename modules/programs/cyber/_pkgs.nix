{pkgs, ...}: (with pkgs; [
  pkgs.nur.repos.sectui.cheatmd # Interactive cheatsheets from Markdown files

  # Web
  pkgs.nur.repos.anotherhadi.spilltea
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
  pkgs.unstable.nuclei
  pkgs.unstable.vulnx
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
  pkgs.nur.repos.anotherhadi.revshell # Reverse shell

  # Reverse
  binsider # Analyzer of executables using a terminal user interface

  # Misc
  metasploit
  openvpn
  zizmor # CI/CD Pipelines
  trufflehog # Look for secrets
  pkgs.nur.repos.anotherhadi.default-creds-tui

  # Forensics
  binwalk
])
