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
    };
  };

  # Add my public SSH key to my user
  users.users."${username}".openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPG9SE80ZyBcXZK/f5ypSKudaM5Jo3XtQikCnGo0jI5E hadi@nixy"
  ];

  services.cloudflared.tunnels."f7c8f777-a36c-4b9a-b6e3-6a112bd43e73".ingress."ssh.hadi.diy" = "ssh://localhost:22";
}
