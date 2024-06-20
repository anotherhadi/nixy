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
      [ ! -d "/home/heaven/btcprice" ] && git clone git@github.com:anotherhadi/btcprice /home/heaven/btcprice
      cd "/home/heaven/btcprice"
      price=$(curl eur.rate.sx/1BTC)
      echo "# Bitcoin Price in EURO" >README.md
      echo "" >>README.md
      echo "1 Bitcoin = $price€" >>README.md
      echo "" >>README.md
      echo "Date: $(date)" >>README.md
      git add .
      git commit -m "Update price (heaven)"
      git push -u origin main
      exit 0
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "heaven";
    };
  };
}
