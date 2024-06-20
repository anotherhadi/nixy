{
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
      [ ! -d "/home/hadi/btcprice" ] && git clone git@github.com:anotherhadi/btcprice /home/hadi/btcprice
      cd "/home/hadi/btcprice"
      price=$(curl eur.rate.sx/1BTC)
      echo "# Bitcoin Price in EURO" >README.md
      echo "" >>README.md
      echo "1 Bitcoin = $price€" >>README.md
      echo "" >>README.md
      echo "Date: $(date)" >>README.md
      git add .
      git commit -m "Update price (hadi)"
      git push -u origin main
      exit 0
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "hadi";
    };
  };
}
