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
    sabnzbd = {
      enable = mkEnableOption {
        description = "Enable SABnzbd";
      };

      port = mkOption {
        description = "Port for SABnzbd";
        default = 6336;
      };

      url = mkOption {
        type = lib.types.str;
        description = "URL of SABnzbd";
        default = "sabnzbd.${homelab.baseDomain}";
      };
    };

  };

  config = mkIf cfg.enable {
    nixarr = {
      sabnzbd = {
        enable = cfg.sabnzbd.enable;
        guiPort = cfg.sabnzbd.port;
      };
    };

    services.sabnzbd.allowConfigWrite = true;

    services.caddy.virtualHosts = {

      "${cfg.sabnzbd.url}" = mkIf cfg.sabnzbd.enable {
        useACMEHost = homelab.baseDomain;

        extraConfig = ''
          route {
              reverse_proxy /outpost.goauthentik.io/* http://outpost.${homelab.baseDomain}:9000

              forward_auth http://outpost.${homelab.baseDomain}:9000 {
                  uri /outpost.goauthentik.io/auth/caddy

                  copy_headers X-Authentik-Username X-Authentik-Groups X-Authentik-Entitlements X-Authentik-Email X-Authentik-Name X-Authentik-Uid X-Authentik-Jwt X-Authentik-Meta-Jwks X-Authentik-Meta-Outpost X-Authentik-Meta-Provider X-Authentik-Meta-App X-Authentik-Meta-Version

                  trusted_proxies private_ranges
              }

              reverse_proxy http://127.0.0.1:${toString cfg.sabnzbd.port}
          }
        '';
      };
    };
  };
}
