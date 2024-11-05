{ config, ... }: {
  services.pia.enable = true;

  # Alternatively, you can use the `authUserPassFile` attribute if you are using
  # a Nix secrets manager. Here's an example using sops-nix.
  #
  # The secret you provide to `authUserPassFile` should be a multiline string with
  # a single username on the first line a single password on the second line.
  services.pia.authUserPassFile = "/home/hadi/.config/pia/pia.ovpn";
}
