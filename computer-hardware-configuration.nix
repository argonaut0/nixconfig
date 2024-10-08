{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];


  # https://nixos.wiki/wiki/Linux_kernel
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_10;
  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod"];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = with config.boot.kernelPackages; [ ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use AMDGPU https://nixos.wiki/wiki/AMD_GPU
  boot.initrd.kernelModules = [ "amdgpu" ];
  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/308c5bf3-bfa6-4e13-85d8-3adac5c04f3e";
      fsType = "xfs";
    };

  boot.initrd.luks.devices."nixos".device = "/dev/disk/by-uuid/7556a37f-a0b2-464c-8f41-e626d7168db4";

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/3AD5-5EA9";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  swapDevices = [ ];


  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp7s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
