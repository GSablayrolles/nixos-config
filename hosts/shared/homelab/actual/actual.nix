{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkOption mkIf;

  service = "actual";
  cfg = config.homelab.services.actual;
  homelab = config.homelab;
in
{
  options.homelab.services.${service} = {
    enable = mkEnableOption {
      description = "Enable ${service}";
    };

    domain = mkOption {
      type = lib.types.str;
      default = "actual";
      description = "The domain for ${service}";
    };

    port = mkOption {
      description = "Port for Actual";
      default = 3000;
    };

    url = mkOption {
      type = lib.types.str;
      description = "URL of Actual";
      default = "${cfg.domain}.${homelab.baseDomain}";
    };

    homepage = {
      name = mkOption {
        type = lib.types.str;
        default = "Actual";
      };
      description = mkOption {
        type = lib.types.str;
        default = "Managing our finances";
      };
      icon = mkOption {
        type = lib.types.str;
        default = "actual-budget.webp";
      };
      category = mkOption {
        type = lib.types.str;
        default = "Apps";
      };
    };
  };

  config = mkIf cfg.enable {
    services.actual = {
      enable = true;
      settings = {
        port = cfg.port;
        hostname = "127.0.0.1";
      };
    };

    services.caddy.virtualHosts."${cfg.url}" = {
      useACMEHost = homelab.baseDomain;

      extraConfig = ''
        route {
            reverse_proxy /outpost.goauthentik.io/* http://outpost.${homelab.baseDomain}:9000

            forward_auth http://outpost.${homelab.baseDomain}:9000 { 
                uri /outpost.goauthentik.io/auth/caddy

                copy_headers X-Authentik-Username X-Authentik-Groups X-Authentik-Entitlements X-Authentik-Email X-Authentik-Name X-Authentik-Uid X-Authentik-Jwt X-Authentik-Meta-Jwks X-Authentik-Meta-Outpost X-Authentik-Meta-Provider X-Authentik-Meta-App X-Authentik-Meta-Version

                trusted_proxies private_ranges
            }
            
          reverse_proxy http://${config.services.actual.settings.hostname}:${toString cfg.port}
        }
      '';
    };
  };
}
