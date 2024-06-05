
# Configuration for computer
{ config, lib, pkgs, ... }:

{
  # tailscale
  # https://github.com/tailscale/tailscale/issues/4254
  # https://nixos.wiki/wiki/Tailscale
  services.resolved.enable = true;
  services.tailscale.enable = true;
  services.tailscale.useRoutingFeatures = "client";
}
