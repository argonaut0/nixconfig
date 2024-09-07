# Configuration for computer
{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./laptop-hardware-configuration.nix
      ./configuration.nix
      ./virt.nix
    ];

  networking.hostName = "laptop"; # Define your hostname.
  services.fprintd.enable = true;
  services.fwupd.enable = true;
  powerManagement.enable = true;
  powerManagement.powertop.enable = true;
  # https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion
  system.stateVersion = "23.11"; 
}
