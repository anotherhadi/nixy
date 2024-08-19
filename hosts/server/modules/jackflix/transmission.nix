# I'm using the transmission-openvpn docker image to be sure that my torrent traffic is going through a VPN.
# Only to download legal stuff of course.
{
  # environment.etc."/etc/transmission.sh" = {
  #   text = ''
  #     docker run --cap-add=NET_ADMIN -d \
  #       -v /var/lib/transmission-openvpn/data:/data \
  #       -v /var/lib/transmission-openvpn/config:/config \
  #       -e OPENVPN_PROVIDER=PIA \
  #       -e OPENVPN_CONFIG=france \
  #       -e OPENVPN_USERNAME=username\
  #       -e OPENVPN_PASSWORD="password" \
  #       -e LOCAL_NETWORK=192.168.2.0/24 \
  #       --log-driver json-file \
  #       --log-opt max-size=10m \
  #       -p 9091:9091 \
  #       haugene/transmission-openvpn
  #   '';
  # };

  networking.firewall.allowedTCPPorts = [ 9091 ];
}
