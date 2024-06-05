# Configuration for computer
{ config, lib, pkgs, ... }:

{
  # use the firefox program instead of package
  # to enable plasma-browser-integration (config installed by plasma)
  programs.firefox.enable = true;
  programs.chromium.enable = true;
  programs.wireshark.enable = true;
  programs.wireshark.package = pkgs.wireshark;


  # https://github.com/quexten/goldwarden
  programs.goldwarden.enable = true;
  programs.goldwarden.useSshAgent = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; 
  };
  programs.virt-manager.enable = true;
}
