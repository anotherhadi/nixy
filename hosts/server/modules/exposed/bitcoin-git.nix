{ pkgs, ... }:
let
  bitcoin-price = pkgs.writeShellScriptBin "bitcoin-price" ''
    [ ! -d "/home/hadi/btcprice" ] && ${pkgs.git}/bin/git clone git@github.com:anotherhadi/btcprice /home/hadi/btcprice
    cd "/home/hadi/btcprice"
    price=$(${pkgs.curl}/bin/curl eur.rate.sx/1BTC)
    echo "# Bitcoin Price in EURO" >README.md
    echo "" >>README.md
    echo "1 Bitcoin = $price€" >>README.md
    echo "" >>README.md
    echo "Date: $(date)" >>README.md
    ${pkgs.git}/bin/git add .
    ${pkgs.git}/bin/git commit -m "Update price (hadi)"
    ${pkgs.git}/bin/git push -u origin main
  '';
in {
  systemd.timers."bitcoin-git" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      Unit = "bitcoin-git.service";
      OnCalendar = "daily";
      Persistent = true;
    };
  };

  systemd.services."bitcoin-git" = {
    script = ''
      ${bitcoin-price}
      exit 0
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "hadi";
    };
  };
}
