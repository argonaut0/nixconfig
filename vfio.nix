# https://astrid.tech/2022/09/22/0/nixos-gpu-vfio/
let
# GTX 1050
gpuIDs = [
  "10de:1c81" # Graphics
  "10de:0fb9" # Audio
];
in { pkgs, lib, config, ... }: {
  options.vfio.enable = with lib;
  mkEnableOption "Configure the machine for VFIO";

  config = let cfg = config.vfio;
  in {
    # force load vfio drivers first
    boot.initrd.kernelModules = lib.mkOrder 50 [
        "vfio_pci"
        "vfio"
        "vfio_iommu_type1"
    ];

    boot.kernelParams = [
      # enable IOMMU
      "amd_iommu=on"
    ] ++ lib.optional cfg.enable ("vfio-pci.ids=" + lib.concatStringsSep "," gpuIDs);

    # blacklist nvidia 1050 gpu for vfio - also nouveau crashes kernel sometimes when compiling apex legends shaders.
    boot.blacklistedKernelModules = [ "nouveau nvidia nvidia_drm nvidia_modeset" ];

    hardware.opengl.enable = true;
    virtualisation.spiceUSBRedirection.enable = true;
  };
}
