{
  description = "NixOS config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland-qtutils = {
      url = "github:hyprwm/hyprland-qtutils";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-minecraft.url = "github:Infinidoge/nix-minecraft";

    authentik-nix = {
      url = "github:nix-community/authentik-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.authentik-src.url = "github:goauthentik/authentik/version-2025.10";
    };

  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      stylix,
      sops-nix,
      authentik-nix,
      ...
    }:
    let
      forEachSystem = nixpkgs.lib.genAttrs [ "x86_64-linux" ];
      forEachPkgs = f: forEachSystem (sys: f nixpkgs.legacyPackages.${sys});

      mkNixos =
        user: host: system:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit (self) inputs outputs; };
          modules = [
            ./hosts/${host}
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = false;
              home-manager.users.${user} = import ./home/${user}/${host}.nix;
              home-manager.extraSpecialArgs = {
                inherit (self) inputs outputs;
              };
              #   home-manager.sharedModules = [
              #     sops-nix.homeManagerModules.sops
              #   ];
            }
            stylix.nixosModules.stylix
            sops-nix.nixosModules.sops
            authentik-nix.nixosModules.default
          ];
        };
    in
    {
      nix.nixPath = [ "nixpkgs=${nixpkgs}" ];
      formatter = forEachPkgs (pkgs: pkgs.nixfmt-rfc-style);

      nixosConfigurations = {
        curiosity = mkNixos "guillaume" "curiosity" "x86_64-linux";
        atlantis = mkNixos "guillaume" "atlantis" "x86_64-linux";
        iss = mkNixos "guillaume" "iss" "x86_64-linux";

      };
    };
}
