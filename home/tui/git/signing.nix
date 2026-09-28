# This file is used to sign git commits using an SSH key.
{
  # CHANGEME: change this to your own SSH key.
  # ~/.ssh/key.pub itself is managed by sops (see hosts/laptop/secrets/default.nix: signing-pub-key).
  home.file.".ssh/allowed_signers".text = "* ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIINhWby7lUUXQNKbRu9/UOrGjWDf3fvoAwGHomWv/+lL";

  programs.git = {
    settings = {
      commit.gpgsign = true;
      gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
      gpg.format = "ssh";
      user.signingkey = "~/.ssh/key.pub";
    };
  };
}
