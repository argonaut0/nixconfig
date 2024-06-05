# Configuration for computer
{ config, lib, pkgs, ... }:

{
  services.syncthing.enable = true;
  services.syncthing.user = "user";
  services.syncthing.dataDir = "/home/user";
  services.syncthing.configDir = "/home/user/.config/syncthing";
}
