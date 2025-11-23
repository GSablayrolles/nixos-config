{ config, ... }:
let
  homelab = config.homelab;
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

  services.caddy.virtualHosts."photos.${homelab.baseDomain}" = {
    useACMEHost = homelab.baseDomain;

    extraConfig = ''
      route {
          reverse_proxy /outpost.goauthentik.io/* http://outpost.${homelab.baseDomain}:9000

          forward_auth http://outpost.${homelab.baseDomain}:9000 {
              uri /outpost.goauthentik.io/auth/caddy

              copy_headers X-Authentik-Username X-Authentik-Groups X-Authentik-Entitlements X-Authentik-Email X-Authentik-Name X-Authentik-Uid X-Authentik-Jwt X-Authentik-Meta-Jwks X-Authentik-Meta-Outpost X-Authentik-Meta-Provider X-Authentik-Meta-App X-Authentik-Meta-Version

              trusted_proxies private_ranges
          }

          reverse_proxy http://${config.services.immich.host}:${toString config.services.immich.port}
      }
    '';
  };
}
