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
    bazarr = {
      enable = mkEnableOption {
        description = "Enable Bazarr";
      };

      port = mkOption {
        description = "Port for Bazarr";
        default = 6767;
      };

      url = mkOption {
        type = lib.types.str;
        description = "URL of Jellyfin";
        default = "bazarr.${homelab.baseDomain}";
      };
    };

    prowlarr = {
      enable = mkEnableOption {
        description = "Enable Prowlarr";
      };

      port = mkOption {
        description = "Port for Prowlarr";
        default = 9696;
      };

      url = mkOption {
        type = lib.types.str;
        description = "URL of Jellyfin";
        default = "prowlarr.${homelab.baseDomain}";
      };
    };

    radarr = {
      enable = mkEnableOption {
        description = "Enable Radarr";
      };

      port = mkOption {
        description = "Port for Radarr";
        default = 7878;
      };

      url = mkOption {
        type = lib.types.str;
        description = "URL of Jellyfin";
        default = "radarr.${homelab.baseDomain}";
      };
    };

    sonarr = {
      enable = mkEnableOption {
        description = "Enable Sonarr";
      };

      port = mkOption {
        description = "Port for Sonarr";
        default = 8989;
      };

      url = mkOption {
        type = lib.types.str;
        description = "URL of Jellyfin";
        default = "sonarr.${homelab.baseDomain}";
      };
    };

  };

  config = mkIf cfg.enable {
    nixarr = {
      bazarr = {
        enable = cfg.bazarr.enable;
        port = cfg.bazarr.port;
      };

      prowlarr = {
        enable = cfg.prowlarr.enable;
        port = cfg.prowlarr.port;
      };

      radarr = {
        enable = cfg.radarr.enable;
        port = cfg.radarr.port;
      };

      sonarr = {
        enable = cfg.sonarr.enable;
        port = cfg.sonarr.port;
      };
    };

    services.caddy.virtualHosts = {

      "${cfg.bazarr.url}" = mkIf cfg.bazarr.enable {
        useACMEHost = homelab.baseDomain;

        extraConfig = ''
          route {
              reverse_proxy /outpost.goauthentik.io/* http://outpost.${homelab.baseDomain}:9000

              forward_auth http://outpost.${homelab.baseDomain}:9000 {
                  uri /outpost.goauthentik.io/auth/caddy

                  copy_headers X-Authentik-Username X-Authentik-Groups X-Authentik-Entitlements X-Authentik-Email X-Authentik-Name X-Authentik-Uid X-Authentik-Jwt X-Authentik-Meta-Jwks X-Authentik-Meta-Outpost X-Authentik-Meta-Provider X-Authentik-Meta-App X-Authentik-Meta-Version

                  trusted_proxies private_ranges
              }

              reverse_proxy http://127.0.0.1:${toString cfg.bazarr.port}
          }
        '';
      };

      "${cfg.prowlarr.url}" = mkIf cfg.prowlarr.enable {
        useACMEHost = homelab.baseDomain;

        extraConfig = ''
          route {
              reverse_proxy /outpost.goauthentik.io/* http://outpost.${homelab.baseDomain}:9000

              forward_auth http://outpost.${homelab.baseDomain}:9000 {
                  uri /outpost.goauthentik.io/auth/caddy

                  copy_headers X-Authentik-Username X-Authentik-Groups X-Authentik-Entitlements X-Authentik-Email X-Authentik-Name X-Authentik-Uid X-Authentik-Jwt X-Authentik-Meta-Jwks X-Authentik-Meta-Outpost X-Authentik-Meta-Provider X-Authentik-Meta-App X-Authentik-Meta-Version

                  trusted_proxies private_ranges
              }

              reverse_proxy http://127.0.0.1:${toString cfg.prowlarr.port}
          }
        '';
      };

      "${cfg.radarr.url}" = mkIf cfg.radarr.enable {
        useACMEHost = homelab.baseDomain;

        extraConfig = ''
          route {
              reverse_proxy /outpost.goauthentik.io/* http://outpost.${homelab.baseDomain}:9000

              forward_auth http://outpost.${homelab.baseDomain}:9000 {
                  uri /outpost.goauthentik.io/auth/caddy

                  copy_headers X-Authentik-Username X-Authentik-Groups X-Authentik-Entitlements X-Authentik-Email X-Authentik-Name X-Authentik-Uid X-Authentik-Jwt X-Authentik-Meta-Jwks X-Authentik-Meta-Outpost X-Authentik-Meta-Provider X-Authentik-Meta-App X-Authentik-Meta-Version

                  trusted_proxies private_ranges
              }

              reverse_proxy http://127.0.0.1:${toString cfg.radarr.port}
          }
        '';
      };

      "${cfg.sonarr.url}" = mkIf cfg.sonarr.enable {
        useACMEHost = homelab.baseDomain;

        extraConfig = ''
          route {
              reverse_proxy /outpost.goauthentik.io/* http://outpost.${homelab.baseDomain}:9000

              forward_auth http://outpost.${homelab.baseDomain}:9000 {
                  uri /outpost.goauthentik.io/auth/caddy

                  copy_headers X-Authentik-Username X-Authentik-Groups X-Authentik-Entitlements X-Authentik-Email X-Authentik-Name X-Authentik-Uid X-Authentik-Jwt X-Authentik-Meta-Jwks X-Authentik-Meta-Outpost X-Authentik-Meta-Provider X-Authentik-Meta-App X-Authentik-Meta-Version

                  trusted_proxies private_ranges
              }

              reverse_proxy http://127.0.0.1:${toString cfg.sonarr.port}
          }
        '';
      };
    };
  };
}
