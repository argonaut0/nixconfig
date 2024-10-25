{
  description = "A simple NixOS flake";

  inputs = {
    # https://nix.dev/manual/nix/2.18/command-ref/new-cli/nix3-flake.html#url-like-syntax
    nixpkgs.url = "github:nixos/nixpkgs";

    # Add https://lix.systems
    lix-module = {
      url = "git+https://git.lix.systems/lix-project/nixos-module";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, lix-module, ... }@inputs: {
    # hostname 'computer'
    nixosConfigurations.computer = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        # Import the previous configuration.nix we used,
        # so the old configuration file still takes effect
        ./computer.nix
        # lix.systems
        lix-module.nixosModules.default
      ];
    };
    nixosConfigurations.laptop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        # Import the previous configuration.nix we used,
        # so the old configuration file still takes effect
        ./laptop.nix
        # lix.systems
        lix-module.nixosModules.default
      ];
    };
    nixosConfigurations.macbook = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [
        # Firefox and Chrome DRM fix
	{
	  nixpkgs.overlays = [
	    (import ./apple-silicon/widevine-overlay.nix)
	  ];
	}
        ./macbook.nix
        # lix.systems
        lix-module.nixosModules.default
      ];
    };
  };
}
