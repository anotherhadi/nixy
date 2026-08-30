# Source: https://github.com/Dylouwu/MyNixy/blob/main/nixos/steam.nix
{
  config,
  pkgs,
  ...
}: {
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };

  environment.systemPackages = with pkgs; [
    mangohud
    protonup-ng
  ];

  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/${config.var.username}/.steam/root/compatibilitytools.d";
  };

  programs.gamemode.enable = true;
}
# Example of recommanded launch options for your games in Steam :
# Regular gaming :
# LD_PRELOAD="" gamescope -W 2560 -H 1440 -r 360 -f -- %command%
# LD_PRELOAD="" gamescope -W 3440 -H 1440 -r 140 -f -- %command%
# HDR gaming :
# LD_PRELOAD="" ENABLE_HDR_WSI=1 gamescope -w 2560 -h 1440 -r 360 -f --hdr-enabled --hdr-debug-force-output --hdr-sdr-content-nits 600 -- env ENABLE_GAMESCOPE_WSI=1 DXVK_HDR=1 DISABLE_HDR_WSI=1 VKD3D_DISABLE_EXTENSIONS=VK_KHR_present_wait %command%
# LD_PRELOAD="" removes a glitch causing games to slow down after roughly 24 minutes
# For the rest of the command, you can change the values to match your screen resolution and refresh rate
