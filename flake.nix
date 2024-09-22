{
  description = "NixOS config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nix-colors,
    ...
  }: let
    forEachSystem = nixpkgs.lib.genAttrs ["x86_64-linux"];
    forEachPkgs = f: forEachSystem (sys: f nixpkgs.legacyPackages.${sys});
    mkNixos = user: host: system:
      nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit (self) inputs outputs nix-colors;};
        modules =
          # let
          #  overlay-master = final: prev: {
          #    master = import nixpkgs-master {
          #      system = final.system;
          #      config.allowUnfree = true;
          #    };
          #  };
          # in
          [
            ./hosts/${host}
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.users.${user} = import ./home/${user}/${host}.nix;
              home-manager.extraSpecialArgs = {
                inherit (self) inputs outputs;
                inherit nix-colors;
              };
            }
            # stylix.nixosModules.stylix
            # ({
            #   config,
            #   pkgs,
            #   stylix,
            #   ...
            # }: {nixpkgs.overlays = [overlay-master];})
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
