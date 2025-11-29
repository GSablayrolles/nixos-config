{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkOption mkIf;

  service = "miniflux";
  cfg = config.homelab.services.miniflux;
  homelab = config.homelab;
in
{
  options.homelab.services.${service} = {
    enable = mkEnableOption {
      description = "Enable ${service}";
    };

    domain = mkOption {
      type = lib.types.str;
      default = "";
      description = "The domain for ${service}";
    };
  };

  config = mkIf cfg.enable {
    sops.secrets.miniflux-creds = {
      sopsFile = ../../secrets.yaml;
    };

    services.${service} = {
      enable = true;
      adminCredentialsFile = config.sops.secrets.miniflux-creds.path;
      config = {
        BASE_URL = "https://${cfg.domain}.${homelab.baseDomain}";
        CREATE_ADMIN = 1;
        LISTEN_ADDR = "127.0.0.1:8070";
      };
    };

    services.caddy.virtualHosts."${cfg.domain}.${homelab.baseDomain}" = {
      useACMEHost = homelab.baseDomain;

      extraConfig = ''
        route {
            reverse_proxy /outpost.goauthentik.io/* http://outpost.${homelab.baseDomain}:9000

            forward_auth http://outpost.${homelab.baseDomain}:9000 {
                uri /outpost.goauthentik.io/auth/caddy

                copy_headers X-Authentik-Username X-Authentik-Groups X-Authentik-Entitlements X-Authentik-Email X-Authentik-Name X-Authentik-Uid X-Authentik-Jwt X-Authentik-Meta-Jwks X-Authentik-Meta-Outpost X-Authentik-Meta-Provider X-Authentik-Meta-App X-Authentik-Meta-Version

                trusted_proxies private_ranges
            }
            
          reverse_proxy http://${config.services.miniflux.config.LISTEN_ADDR}
        }
      '';
    };
  };
}
