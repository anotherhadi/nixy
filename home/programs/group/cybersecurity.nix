{
  pkgs-stable,
  pkgs,
  ...
}: {
  home.packages = with pkgs-stable; [
    wireshark
    nmap
    john
    hashcat
    metasploit
    haiti
    hydra
    dnsrecon
    whois
    dig
    nosqli
    jwt-cli
    nuclei

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

  home.file = {
    "Cyber/wordlists/seclists" = {
      source = pkgs.fetchFromGitHub {
        owner = "danielmiessler";
        repo = "SecLists";
        rev = "47aa98053fce8670c6489e4f6fb57dc34881d8bd";
        hash = "sha256-ojXLB/TXap1Qi0MtV5/WJlJpjNIDYx/sLY2KHm0uFKI=";
      };
    };

    "Cyber/wordlists/fuzz4bounty" = {
      source = pkgs.fetchFromGitHub {
        owner = "0xPugal";
        repo = "fuzz4bounty";
        rev = "a805f6b434033f054312da0ddc2bc3021cc9a3b0";
        hash = "sha256-wMhx1CcxIyw2E7gJXQxXAFc7m5nYt0FXNkoTZqFMQh4=";
      };
    };

    # RULES
    "Cyber/wordlists/rules/oneruletorulethemstill".source = pkgs.fetchFromGitHub {
      owner = "stealthsploit";
      repo = "oneruletorulethemstill";
      rev = "4bfb7322e189305b5f35bb7fcd4e9cc233c3d3c6";
      hash = "sha256-h7MeymIXS/6wlPRt4lzsIEqOOssP0lDx9nQip65cwZw=";
    };

    "Cyber/wordlists/rules/best64.rule" = {
      source = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/CarlosLannister/OwadeReborn/refs/heads/master/owade/fileAnalyze/hashcatLib/best64.rule%7E";
        hash = "sha256-T0XkMHJZQiy63/j25nGTkaiDFjc+blmgEVGTAFgVylU=";
      };
    };
  };
}
