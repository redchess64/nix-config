{inputs, ...}: {
  imports = with inputs; [
    catppuccin.nixosModules.catppuccin
    nvf.nixosModules.default
    spicetify-nix.nixosModules.default
    home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.calebh = {
        imports = [
          ./home.nix
          catppuccin.homeModules.catppuccin
        ];
      };
      # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
      home-manager.extraSpecialArgs = {
        pkgs-unstable = import nixpkgs-unstable {
          inherit system;
        };
      };
    }
  ];
}
