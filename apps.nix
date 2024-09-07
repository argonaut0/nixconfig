# Configuration for computer
{ config, lib, pkgs, ... }:

{
  # use the firefox program instead of package
  # to enable plasma-browser-integration (config installed by plasma)
  programs.firefox.enable = true;
  programs.firefox.preferences = {
    "widget.use-xdg-desktop-portal.file-picker" = 1;
  };
  programs.wireshark.enable = true;
  programs.wireshark.package = pkgs.wireshark;

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
