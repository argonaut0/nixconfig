# Configuration for computer
{ config, lib, pkgs, ... }:

{


  programs.steam = {
    enable = false;
    remotePlay.openFirewall = true; 
    dedicatedServer.openFirewall = true;
    gamescopeSession = {
      enable = true;
      env = {
        WLR_RENDERER = "vulkan";
        DXVK_HDR = "1";
        ENABLE_GAMESCOPE_WSI = "1";
        WINE_FULLSCREEN_FSR = "1";
# Games allegedly prefer X11
      };
      args = [
          "--expose-wayland"
          "-e" # Enable steam integration
          "--steam"
          "--adaptive-sync"
          "-r 165"
          "--hdr-enabled"
          "--hdr-itm-enable"
#  DP output
          "--prefer-output DP-2"
      ];
    };
  };
  programs.gamescope.enable = false;
}
