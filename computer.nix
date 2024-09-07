# Configuration for computer
{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./computer-hardware-configuration.nix
      ./configuration.nix
      ./virt.nix
      # enable/disable APC communication
      #./apcupsd.nix
    ];

  vfio.enable = true;
  networking.hostName = "computer"; # Define your hostname.

  # Enable ntfs-3g - https://wiki.nixos.org/wiki/NTFS
  boot.supportedFilesystems = [ "ntfs" ];
  # https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion
  system.stateVersion = "23.11"; 
}
