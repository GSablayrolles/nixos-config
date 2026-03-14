{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkOption mkIf;

  service = "jellyfin";
  cfg = config.homelab.services.nixarr;
  homelab = config.homelab;
in
{
  options.homelab.services.nixarr = {
    jellyfin = {
      enable = mkEnableOption {
        description = "Enable ${service}";
      };

      domain = mkOption {
        type = lib.types.str;
        default = "jellyfin";
        description = "The domain for ${service}";
      };

      url = mkOption {
        type = lib.types.str;
        description = "URL of ${service}";
        default = "${cfg.jellyfin.domain}.${homelab.baseDomain}";
      };

      homepage = {
        name = mkOption {
          type = lib.types.str;
          default = "Jellyfin";
        };
        description = mkOption {
          type = lib.types.str;
          default = "Our media library";
        };
        icon = mkOption {
          type = lib.types.str;
          default = "jellyfin.webp";
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
      jellyfin = {
        enable = cfg.jellyfin.enable;
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
    };
  };
}
