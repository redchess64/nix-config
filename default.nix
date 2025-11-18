let
  inputs = import ./inputs.nix;
  pkgs = inputs.pkgs;
  eval-config = import ((import ./npins).nixpkgs + "/nixos/lib/eval-config.nix");
  mkHost = {
    modules,
    ...
  }: eval-config {
    system = null;
    modules = [
      {
        nixpkgs.pkgs = pkgs;
        nixpkgs.localSystem = pkgs.stdenv.hostPlatform;
      }
    ] ++ modules;
    specialArgs = {
      inherit inputs;
    };
  };
in
{
  
    desktop = mkHost {
      modules = [
        ./machines/desktop/hardware.nix
        ./common/common.nix
      ];
    };
  
}
