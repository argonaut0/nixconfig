{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # misc tools
    pciutils
    dig
    htop
    wget
    zip
    unzip
  ];
}

