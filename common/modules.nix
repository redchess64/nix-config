{inputs, ...}: {
  imports = with inputs; [
    nvf.nixosModules.default
    spicetify-nix.nixosModules.default
    nix-stow.nixosModules.default
  ];
}
