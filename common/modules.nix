{inputs, ...}: {
  imports = with inputs; [
    catppuccin.nixosModules.catppuccin
    nvf.nixosModules.default
    spicetify-nix.nixosModules.default
    home-manager.nixosModules.home-manager
  ];
}
