# SSH configuration
{config, ...}: let
  username = config.var.username;
in {
  services.openssh = {
    enable = true;
    ports = [22];
    openFirewall = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      AllowUsers = [username];
      MaxAuthTries = 3;
      LoginGraceTime = 20;
      X11Forwarding = false;
      AllowAgentForwarding = false;
      AllowTcpForwarding = false;
      ClientAliveInterval = 300;
      ClientAliveCountMax = 2;
      KexAlgorithms = ["curve25519-sha256" "curve25519-sha256@libssh.org"];
      Ciphers = ["chacha20-poly1305@openssh.com" "aes256-gcm@openssh.com"];
    };
  };

  # Add my public SSH key to my user
  users.users."${username}".openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPG9SE80ZyBcXZK/f5ypSKudaM5Jo3XtQikCnGo0jI5E hadi@nixy"
  ];

  services.cloudflared.tunnels."${config.var.tunnelId}".ingress."ssh.${config.var.domain}" = "ssh://localhost:22";
}
