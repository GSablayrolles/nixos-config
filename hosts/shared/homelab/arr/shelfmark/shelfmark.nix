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
    shelfmark = {
      enable = mkEnableOption {
        description = "Enable Shelfmark";
      };

      port = mkOption {
        description = "Port for Shelfmark";
        default = 8084;
      };

      url = mkOption {
        type = lib.types.str;
        description = "URL of Shelfmark";
        default = "books.${homelab.baseDomain}";
      };
    };

  };

  config = mkIf cfg.enable {
    nixarr = {
      shelfmark = {
        enable = cfg.shelfmark.enable;
        port = cfg.shelfmark.port;
	host = "0.0.0.0";
      };
    };

    services.caddy.virtualHosts = {

      "${cfg.shelfmark.url}" = mkIf cfg.shelfmark.enable {
        useACMEHost = homelab.baseDomain;

        extraConfig = ''
          route {
              reverse_proxy /outpost.goauthentik.io/* http://outpost.${homelab.baseDomain}:9000

              forward_auth http://outpost.${homelab.baseDomain}:9000 {
                  uri /outpost.goauthentik.io/auth/caddy

                  copy_headers X-Authentik-Username X-Authentik-Groups X-Authentik-Entitlements X-Authentik-Email X-Authentik-Name X-Authentik-Uid X-Authentik-Jwt X-Authentik-Meta-Jwks X-Authentik-Meta-Outpost X-Authentik-Meta-Provider X-Authentik-Meta-App X-Authentik-Meta-Version

                  trusted_proxies private_ranges
              }

              reverse_proxy http://127.0.0.1:${toString cfg.shelfmark.port}
          }
        '';
      };
    };
  };
}
