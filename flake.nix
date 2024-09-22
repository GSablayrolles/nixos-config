{
  description = "NixOS config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    stylix,
    ...
  }: let
    forEachSystem = nixpkgs.lib.genAttrs ["x86_64-linux"];
    forEachPkgs = f: forEachSystem (sys: f nixpkgs.legacyPackages.${sys});
    mkNixos = user: host: system:
      nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit (self) inputs outputs;};
        modules = [
          ./hosts/${host}
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.users.${user} = import ./home/${user}/${host}.nix;
            home-manager.extraSpecialArgs = {
              inherit (self) inputs outputs;
            };
          }
          stylix.nixosModules.stylix
        ];
      };
  in {
    formatter = forEachPkgs (pkgs: pkgs.alejandra);

    nixosConfigurations = {
      curiosity = mkNixos "guillaume" "curiosity" "x86_64-linux";
      atlantis = mkNixos "guillaume" "atlantis" "x86_64-linux";
    };
  };
}
