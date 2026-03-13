{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkOption mkIf;

  cfg = config.homelab.services.nixarr;
  homelab = config.homelab;

in
{
  options.homelab.services.nixarr = {
    jellyfin = {
      enable = mkEnableOption {
        description = "Enable Jellyfin";
      };

      url = mkOption {
        type = lib.types.str;
        description = "URL of Jellyfin";
        default = "jellyfin.${homelab.baseDomain}";
      };
    };

    jellyseerr = {
      enable = mkEnableOption {
        description = "Enable Jellyseerr";
      };

      port = mkOption {
        description = "Port for Jellyseerr";
        default = 5055;
      };

      url = mkOption {
        type = lib.types.str;
        description = "URL of Jellyseerr";
        default = "jellyseerr.${homelab.baseDomain}";
      };
    };
  };

  config = mkIf cfg.enable {
    nixarr = {
      jellyfin = {
        enable = cfg.jellyfin.enable;
      };

      jellyseerr = {
        enable = cfg.jellyseerr.enable;
        port = cfg.jellyseerr.port;
      };
    };

    services.caddy.virtualHosts = {

      "${cfg.jellyfin.url}" = mkIf cfg.jellyfin.enable {
        useACMEHost = homelab.baseDomain;

        extraConfig = ''
          route {
              reverse_proxy /outpost.goauthentik.io/* http://outpost.${homelab.baseDomain}:9000

              forward_auth http://outpost.${homelab.baseDomain}:9000 {
                  uri /outpost.goauthentik.io/auth/caddy

                  copy_headers X-Authentik-Username X-Authentik-Groups X-Authentik-Entitlements X-Authentik-Email X-Authentik-Name X-Authentik-Uid X-Authentik-Jwt X-Authentik-Meta-Jwks X-Authentik-Meta-Outpost X-Authentik-Meta-Provider X-Authentik-Meta-App X-Authentik-Meta-Version

                  trusted_proxies private_ranges
              }

              reverse_proxy http://127.0.0.1:8096
          }
        '';
      };

      "${cfg.jellyseerr.url}" = mkIf cfg.jellyseerr.enable {
        useACMEHost = homelab.baseDomain;

        extraConfig = ''
          route {
              reverse_proxy /outpost.goauthentik.io/* http://outpost.${homelab.baseDomain}:9000

              forward_auth http://outpost.${homelab.baseDomain}:9000 {
                  uri /outpost.goauthentik.io/auth/caddy

                  copy_headers X-Authentik-Username X-Authentik-Groups X-Authentik-Entitlements X-Authentik-Email X-Authentik-Name X-Authentik-Uid X-Authentik-Jwt X-Authentik-Meta-Jwks X-Authentik-Meta-Outpost X-Authentik-Meta-Provider X-Authentik-Meta-App X-Authentik-Meta-Version

                  trusted_proxies private_ranges
              }

              reverse_proxy http://127.0.0.1:${toString cfg.jellyseerr.port}
          }
        '';
      };
    };
  };
}
