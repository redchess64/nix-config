let
  sources = import ./npins;
  inputs = {
    pkgs = (import sources.nixpkgs) (import ./pkg-config.nix);
    pkgs-unstable = (import sources.nixpkgs-unstable) {};
    mnw = import sources.mnw;
    spicetify-nix = import sources.spicetify-nix {inherit (inputs) pkgs;};
    nix-stow = import sources.nix-stow;
  };
in
  inputs
