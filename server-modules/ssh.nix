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

  services.cloudflared.tunnels."a1dfa315-7fc3-4a65-8c02-8387932c35c3".ingress."ssh.hadi.icu" = "ssh://localhost:22";
}
