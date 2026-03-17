{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkOption mkIf;

  service = "immich";
  cfg = config.homelab.services.immich;
  homelab = config.homelab;
in
{

  options.homelab.services.immich = {
    enable = mkEnableOption {
      description = "Enable ${service}";
    };

    domain = mkOption {
      type = lib.types.str;
      default = "photos";
      description = "The domain for ${service}";
    };

    url = mkOption {
      type = lib.types.str;
      description = "URL of Immich";
      default = "${cfg.domain}.${homelab.baseDomain}";
    };

    homepage = {
      name = mkOption {
        type = lib.types.str;
        default = "Immich";
      };
      description = mkOption {
        type = lib.types.str;
        default = "Self hosting alternative to Google Photos";
      };
      icon = mkOption {
        type = lib.types.str;
        default = "immich.svg";
      };
      category = mkOption {
        type = lib.types.str;
        default = "Media";
      };
    };
  };

  config = mkIf cfg.enable {
    users.users.immich.extraGroups = [
      "video"
      "render"
    ];

    networking.firewall.allowedTCPPorts = [
      2283
    ];

    services.immich = {
      enable = cfg.enable;
      port = 2283;
      machine-learning.enable = false;
      openFirewall = true;
      host = "0.0.0.0";
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

            reverse_proxy http://${config.services.immich.host}:${toString config.services.immich.port}
        }
      '';
    };
  };
}
