_: {
  home.file.".ssh/allowed_signers".text =
    "* ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEL3Zww0ptA9VQ0U9qhUFOl1FRS7NJOr7bwVuv+2xBRY nazariipalahnii@gmail.com";
  programs.git.extraConfig = {
    commit.gpgsign = true;
    gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
    gpg.format = "ssh";
    user.signingkey = "~/.ssh/key.pub";
  };
}
