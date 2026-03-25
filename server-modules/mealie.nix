# Mealie is a recipe management and meal planning application.
{config, ...}: {
  services.mealie = {
    enable = true;
    port = 8092;
  };

  services.cloudflared.tunnels."a1dfa315-7fc3-4a65-8c02-8387932c35c3".ingress."mealie.hadi.icu" = "http://localhost:${toString config.services.mealie.port}";
}
