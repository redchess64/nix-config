{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    catppuccin.url = "github:catppuccin/nix";
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # home-manager, used for managing user configuration
    home-manager = {
      url = "github:nix-community/home-manager/";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    nixpkgs,
    nixpkgs-unstable,
    catppuccin,
    home-manager,
    nvf,
    ...
  }: {
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
    nixosConfigurations = {
      desktop = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";

        specialArgs = {
          pkgs-unstable = import nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
          };
        };

        modules = [
          ./machines/desktop/configuration.nix
          catppuccin.nixosModules.catppuccin
          nvf.nixosModules.default

          # make home-manager as a module of nixos
          # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            # TODO replace ryan with your own username
            home-manager.users.calebh = {
              imports = [
                ./home.nix
                catppuccin.homeManagerModules.catppuccin
              ];
            };
            # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
            home-manager.extraSpecialArgs = {
              pkgs-unstable = import nixpkgs-unstable {
                inherit system;
                config.allowUnfree = true;
              };
            };
          }
        ];
      };
    };
  };
}
