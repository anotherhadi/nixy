# Mealie is a recipe management and meal planning application.
{config, ...}: {
  services.mealie = {
    enable = true;
    port = 8092;
  };

  services.cloudflared.tunnels."${config.var.tunnelId}".ingress."mealie.${config.var.domain}" = "http://localhost:${toString config.services.mealie.port}";
}
