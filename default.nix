let
  inputs = import ./inputs.nix;
  pkgs = inputs.pkgs;
  lib = pkgs.lib;
  eval-config = import ((import ./npins).nixpkgs + "/nixos/lib/eval-config.nix");
  ls = dir: (lib.mapAttrsToList (name: _: dir + "/${name}") (builtins.readDir dir) );
  mkHost = {modules, ...}:
    eval-config {
      system = null;
      modules =
        [
          {
            nixpkgs.pkgs = pkgs;
            nixpkgs.localSystem = pkgs.stdenv.hostPlatform;
          }
        ]
        ++ modules
        ++ ls ./common;
      specialArgs = {
        inherit inputs;
      };
    };
in {
  desktop = mkHost {
    modules = [
      ./machines/desktop/hardware.nix
    ];
  };
}
