# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./macbook-hardware-configuration.nix
      ./apple-silicon-support
      ./configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "macbook"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager = {
    enable = true;
    # Apple Silicon prefers iwd, since wpa_supplicant does not support WPA3 on broadcom chip
    wifi.backend = "iwd";
  };

  # Required for Touchpad support
  services.libinput.enable = true;

  hardware.asahi = {
    useExperimentalGPUDriver = true;
    setupAsahiSound = true;
  };
  hardware.bluetooth.enable = true;

  services.power-profiles-daemon.enable = true;
  powerManagement.enable = true;
  powerManagement.powertop.enable = true;
  system.stateVersion = "24.11";
}

