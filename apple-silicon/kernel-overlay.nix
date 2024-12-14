final: prev: let
  nixpkgs-asahi = import inputs.apple-silicon.inputs.nixpkgs {};
in {
  linux-asahi = nixpkgs-asahi.callPackage "${inputs.apple-silicon}/apple-silicon-support/packages/linux-asahi" { };
}
