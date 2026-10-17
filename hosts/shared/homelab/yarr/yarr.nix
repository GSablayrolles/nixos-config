{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkOption mkIf;

  service = "yarr";
  cfg = config.homelab.services.yarr;
  homelab = config.homelab;
in
{
  options.homelab.services.${service} = {
    enable = mkEnableOption {
      description = "Enable ${service}";
    };

    domain = mkOption {
      type = lib.types.str;
      default = "yarr";
      description = "The domain for ${service}";
    };

    url = mkOption {
      type = lib.types.str;
      description = "URL of Yarr";
      default = "${cfg.domain}.${homelab.baseDomain}";
    };

    port = mkOption {
      description = "Port for Yarr";
      default = 8989;
    };

    homepage = {
      name = mkOption {
        type = lib.types.str;
        default = "Yarr";
      };
      description = mkOption {
        type = lib.types.str;
        default = "Personnal RSS feed";
      };
      icon = mkOption {
        type = lib.types.str;
        default = "yarr-light.svg";
      };
      category = mkOption {
        type = lib.types.str;
        default = "Apps";
      };
    };
  };

  config = mkIf cfg.enable {

    services.${service} = {
      enable = true;
      address = "localhost";
      port = cfg.port;
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
            
          reverse_proxy http://${config.services.yarr.address}:${toString cfg.port}
        }
      '';
    };
  };
}
