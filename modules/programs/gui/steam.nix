# Source: https://github.com/Dylouwu/MyNixy/blob/main/nixos/steam.nix
{aspects, ...}: {
  flake.modules.nixos.steam = {
    config,
    lib,
    pkgs,
    ...
  }: {
    imports = [aspects.hjem];
    hjem.extraModules = [{persist.directories = [".steam"];}];

    programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
      # PRIME offload: run Steam and every game it launches on the Nvidia dGPU
      package = pkgs.steam.override {
        extraEnv = lib.optionalAttrs config.hardware.nvidia.prime.offload.enable {
          __NV_PRIME_RENDER_OFFLOAD = "1";
          __NV_PRIME_RENDER_OFFLOAD_PROVIDER = "NVIDIA-G0";
          __GLX_VENDOR_LIBRARY_NAME = "nvidia";
          __VK_LAYER_NV_optimus = "NVIDIA_only";
        };
      };
    };

    environment.systemPackages = with pkgs; [
      mangohud
      protonup-ng
    ];

    environment.sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "${config.users.users.${config.nixy.username}.home}/.steam/root/compatibilitytools.d";
    };

    programs.gamemode.enable = true;
  };
}
