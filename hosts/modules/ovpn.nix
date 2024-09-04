{
  boot.initrd.network.openvpn.enable = false;

  services.openvpn = {
    servers."ovpn" = {
      config = "config /home/hadi/.ovpn.ovpn";
      autoStart = false;
    };
  };
}
