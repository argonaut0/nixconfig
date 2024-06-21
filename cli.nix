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
    kubectl-node-shell
    k9s
    kubernetes-helm
    # https://tofuutils.github.io/tenv/
    tenv
    tree
  ];
}

