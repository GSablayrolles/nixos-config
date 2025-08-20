{ config, ... }:
let
  baseDomain = "ferrets-home.party";
in
{
  users.users.immich.extraGroups = [
    "video"
    "render"
  ];

  services.immich = {
    enable = false;
    port = 2283;
    # mediaLocation = "/home/guillaume/Services/Immich";
  };

  services.caddy.virtualHosts."photos.${baseDomain}" = {
    useACMEHost = baseDomain;

    extraConfig = ''
      reverse_proxy http://${config.services.immich.host}:${toString config.services.immich.port}
    '';
  };
}
