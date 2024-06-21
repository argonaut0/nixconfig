# Configuration for computer
{ config, lib, pkgs, ... }:

{
  # use the firefox program instead of package
  # to enable plasma-browser-integration (config installed by plasma)
  programs.firefox.enable = true;
  programs.firefox.preferences = {
    "widget.use-xdg-desktop-portal.file-picker" = 1;
  };
  programs.chromium.enable = true;
  programs.wireshark.enable = true;
  programs.wireshark.package = pkgs.wireshark;


  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; 
  };
  programs.virt-manager.enable = true;
}
