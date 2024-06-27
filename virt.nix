

# Configuration for computer
{ config, lib, pkgs, ... }:

{
  imports = [
    ./vfio.nix
  ];
  # Enable virtualization
  virtualisation.libvirtd.enable = true;
  virtualisation.containers.enable = true;
  virtualisation.podman.enable = true;
  virtualisation.podman.defaultNetwork.settings.dns_enabled = true;
  # Enable Docker - https://wiki.nixos.org/wiki/Docker
  virtualisation.docker.enable = true;
  virtualisation.docker.enableOnBoot = true;
  users.extraGroups.docker.members = [ "user" ];
}
