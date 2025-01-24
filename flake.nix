{
  description = "A simple NixOS flake";

  inputs = {
    # https://nix.dev/manual/nix/2.18/command-ref/new-cli/nix3-flake.html#url-like-syntax
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Add https://lix.systems
    lix = {
      url = "https://git.lix.systems/lix-project/lix/archive/2.92.0.tar.gz";
      flake = false;
    };

    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.92.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.lix.follows = "lix";
    };

    apple-silicon-support = {
      url = "https://github.com/tpwrules/nixos-apple-silicon/archive/main.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, lix-module, lix, apple-silicon-support, ... }@inputs: {
    # hostname 'computer'
    nixosConfigurations.computer = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        # Import the previous configuration.nix we used,
        # so the old configuration file still takes effect
        ./computer.nix
        # lix.systems
        #lix-module.nixosModules.default
      ];
    };
    nixosConfigurations.laptop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        # Import the previous configuration.nix we used,
        # so the old configuration file still takes effect
        ./laptop.nix
        # lix.systems
        #lix-module.nixosModules.default
      ];
    };
    nixosConfigurations.macbook = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [
        # Firefox and Chrome DRM fix
        {
          nixpkgs.overlays = [
            (import ./apple-silicon/widevine-overlay.nix)
            apple-silicon-support.overlays.apple-silicon-overlay
          ];
        }
        ./macbook.nix
        # lix.systems
        lix-module.nixosModules.default
        apple-silicon-support.nixosModules.apple-silicon-support
      ];
    };
  };
}
