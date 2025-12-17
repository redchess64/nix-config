let
  inputs = import ./inputs.nix;
  pkgs = inputs.pkgs;
  lib = pkgs.lib;
  eval-config = import ((import ./npins).nixpkgs + "/nixos/lib/eval-config.nix");
  ls = dirs: lib.flatten (
    map
      ( dir: (lib.mapAttrsToList (name: _: dir + "/${name}") (builtins.readDir dir)))
    dirs);
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
        ++ ls modules;
      specialArgs = {
        inherit inputs;
      };
    };
in {
  desktop = mkHost {
    modules = [
      ./common
      ./machines/desktop
    ];
  };
}
