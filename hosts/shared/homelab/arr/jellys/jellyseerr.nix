{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkOption mkIf;

  service = "jellyseerr";
  cfg = config.homelab.services.nixarr;
  homelab = config.homelab;
in
{
  options.homelab.services.nixarr = {

    jellyseerr = {
      enable = mkEnableOption {
        description = "Enable ${service}";
      };

      port = mkOption {
        description = "Port for ${service}";
        default = 5055;
      };

      domain = mkOption {
        type = lib.types.str;
        default = "jellyseerr";
        description = "The domain for ${service}";
      };

      url = mkOption {
        type = lib.types.str;
        description = "URL of Jellyseerr";
        default = "${cfg.jellyseerr.domain}.${homelab.baseDomain}";
      };

      homepage = {
        name = mkOption {
          type = lib.types.str;
          default = "Jellyseerr";
        };
        description = mkOption {
          type = lib.types.str;
          default = "Movies/Series catalog to download";
        };
        icon = mkOption {
          type = lib.types.str;
          default = "jellyseerr.webp";
        };
        category = mkOption {
          type = lib.types.str;
          default = "Media";
        };
      };
    };
  };

  config = mkIf cfg.enable {
    nixarr = {

      jellyseerr = {
        enable = cfg.jellyseerr.enable;
        port = cfg.jellyseerr.port;
      };
    };

    services.caddy.virtualHosts = {
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
