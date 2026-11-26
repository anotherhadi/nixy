# signal-cli-rest-api
{
  flake.modules.nixos.signal-api = {
    nixy.server.proxies.signal = "http://100.126.57.68:8080";
  };
}
