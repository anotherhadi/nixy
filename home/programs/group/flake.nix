{
  inputs,
  pkgs,
  pkgs-stable,
  system,
  ...
}: {
  packages.${system} = {
    dev = pkgs.buildEnv {
      name = "dev-tools";
      paths =
        (with pkgs; [
          go
          bun
          nodejs
          air
          duckdb
          claude-code
          inputs.bun2nix.packages.${system}.default
        ])
        ++ (with pkgs-stable; [
          docker
          python3
          jq
          just
        ]);
    };

    cybersecurity = pkgs.buildEnv {
      name = "cybersecurity-tools";
      paths = with pkgs-stable; [
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
        caido
        gobuster
        dirb
        ffuf
        sqlmap
        inetutils
        samba
        openvpn
        mariadb
        redis
      ];
    };
  };

  homeManagerModules = {
    dev = {
      _module.args.pkgs-stable = pkgs-stable;
      imports = [./dev.nix];
    };
    cybersecurity = {
      _module.args.pkgs-stable = pkgs-stable;
      imports = [./cybersecurity.nix];
    };
  };
}
