# Configuration for computer
{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./laptop-hardware-configuration.nix
      ./configuration.nix
    ];

  networking.hostName = "laptop"; # Define your hostname.
  services.fprintd.enable = true;
  services.fwupd.enable = true;
  powerManagement.enable = true;
  powerManagement.powertop.enable = true;
}
