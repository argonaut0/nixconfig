# Configuration for computer
{ config, lib, pkgs, ... }:

{
  services.apcupsd.enable = true;
  services.apcupsd.configText =
  ''
    UPSNAME br1000s
    UPSTYPE net
    DEVICE 10.246.110.10:3551
    BATTERYLEVEL 90
    ONBATTERYDELAY 60
  '';
}
