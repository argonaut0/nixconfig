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
    kubectl
    k9s
    helm
    # https://tofuutils.github.io/tenv/
    tenv
    tree
  ];
}

