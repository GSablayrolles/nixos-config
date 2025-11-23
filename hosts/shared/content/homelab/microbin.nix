{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  service = "microbin";
  cfg = config.homelab.services.microbin;
  homelab = config.homelab;
in
{
  options.homelab.services.microbin = {
    enable = mkEnableOption {
      description = "Enable ${service}";
    };
  };

  config = mkIf cfg.enable {
    services.microbin = {
      enable = true;
      settings = {
        MICROBIN_WIDE = true;
        MICROBIN_MAX_FILE_SIZE_UNENCRYPTED_MB = 2048;
        #   MICROBIN_PUBLIC_PATH = "https://${cfg.url}/";
        MICROBIN_BIND = "127.0.0.1";
        MICROBIN_PORT = 8069;
        MICROBIN_HIDE_LOGO = true;
        MICROBIN_HIGHLIGHTSYNTAX = true;
        MICROBIN_HIDE_HEADER = true;
        MICROBIN_HIDE_FOOTER = true;
      };
    };

    services.caddy.virtualHosts."mc.${homelab.baseDomain}" = {
      useACMEHost = homelab.baseDomain;

      extraConfig = ''
        route {
            reverse_proxy /outpost.goauthentik.io/* http://outpost.${homelab.baseDomain}:9000

            forward_auth http://outpost.${homelab.baseDomain}:9000 {
                uri /outpost.goauthentik.io/auth/caddy

                copy_headers X-Authentik-Username X-Authentik-Groups X-Authentik-Entitlements X-Authentik-Email X-Authentik-Name X-Authentik-Uid X-Authentik-Jwt X-Authentik-Meta-Jwks X-Authentik-Meta-Outpost X-Authentik-Meta-Provider X-Authentik-Meta-App X-Authentik-Meta-Version

                trusted_proxies private_ranges
            }
            
          reverse_proxy http://${config.services.microbin.settings.MICROBIN_BIND}:${toString config.services.microbin.settings.MICROBIN_PORT}
        }
      '';
    };
  };
}
