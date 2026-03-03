{
  pkgs,
  inputs,
  ...
}:
let
  myOpsJson = pkgs.writeText "ops.json" (
    builtins.toJSON [
      {
        uuid = "06c132fc-5ea6-49f0-a7a0-4712d2d8159c";
        name = "ShardZ_";
        level = 2;
        bypassesPlayerLimit = true;
      }
      {
        uuid = "40109128-7c9f-4c9a-b087-0b993f0dea47";
        name = "Moooreo";
        level = 2;
        bypassesPlayerLimit = true;
      }
    ]
  );
in
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
          op-permission-level = 2;

          #server-port = 25565;
        };

        jvmOpts = "-Xms2G -Xmx4G";

        files = {
          "ops.json" = myOpsJson;
        };

      };
    };
  };
}
