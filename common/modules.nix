{inputs, ...}: {
  imports = with inputs; [
    spicetify-nix.nixosModules.default
    nix-stow.nixosModules.default
    mnw.nixosModules.default
  ];
}
