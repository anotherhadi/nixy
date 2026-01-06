# Mealie is a recipe management and meal planning application.
{config, ...}: {
  services.mealie = {
    enable = true;
    port = 8092;
  };

  services.cloudflared.tunnels."f7c8f777-a36c-4b9a-b6e3-6a112bd43e73".ingress."mealie.hadi.diy" = "http://localhost:${toString config.services.mealie.port}";
}
