{
  pkgs,
  lib,
  inputs,
  ...
}:
{
  imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];
  nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];

  services.minecraft-servers = {
    enable = true;
    eula = true;

    servers = {
      ferrets-server = {
        enable = true;
        package = pkgs.vanillaServers.vanilla-1_21;

        openFirewall = true;

        serverProperties = {
          gameMode = "survival";
          difficulty = "normal";
          online-mode = true;

          #server-port = 25565;
        };
      };
    };
  };
}
