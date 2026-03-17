{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkOption mkIf;

  service = "tailscale";
  cfg = config.homelab.services.tailscale;
  homelab = config.homelab;

in
{
  options.homelab.services.${service} = {
    enable = mkEnableOption {
      description = "Enable ${service}";
    };

    port = mkOption {
      description = "Port for Tailscale";
      default = 41641;
    };

    domain = mkOption {
      type = lib.types.str;
      default = "vpn";
      description = "The domain for ${service}";
    };

    url = mkOption {
      type = lib.types.str;
      description = "URL of Tailscale";
      default = "${cfg.domain}.${homelab.baseDomain}";
    };

    homepage = {
      name = mkOption {
        type = lib.types.str;
        default = "Tailscale";
      };
      description = mkOption {
        type = lib.types.str;
        default = "Mesh VPN built on WireGuard";
      };
      icon = mkOption {
        type = lib.types.str;
        default = "tailscale.svg";
      };
      category = mkOption {
        type = lib.types.str;
        default = "Auth";
      };
    };
  };

  config = mkIf cfg.enable {
    sops.secrets.tailscale-key = {
      sopsFile = ../../secrets.yaml;
    };

    environment.systemPackages = with pkgs; [
      tailscale
    ];

    networking.firewall = {
      enable = true;
      trustedInterfaces = [ "tailscale0" ];
      #   allowedUDPPorts = [ config.services.tailscale.port ];
      #   allowedTCPPorts = [ config.services.tailscale.port ];
    };

    services = {
      tailscale = {
        enable = true;
        port = cfg.port;
        authKeyFile = config.sops.secrets.tailscale-key.path;
      };

      caddy.virtualHosts = {
        "${cfg.url}" = mkIf cfg.enable {
          useACMEHost = homelab.baseDomain;

          extraConfig = ''
            route {
                reverse_proxy /outpost.goauthentik.io/* http://outpost.${homelab.baseDomain}:9000

                forward_auth http://outpost.${homelab.baseDomain}:9000 {
                    uri /outpost.goauthentik.io/auth/caddy

                    copy_headers X-Authentik-Username X-Authentik-Groups X-Authentik-Entitlements X-Authentik-Email X-Authentik-Name X-Authentik-Uid X-Authentik-Jwt X-Authentik-Meta-Jwks X-Authentik-Meta-Outpost X-Authentik-Meta-Provider X-Authentik-Meta-App X-Authentik-Meta-Version

                    trusted_proxies private_ranges
                }

                reverse_proxy http://127.0.0.1:${toString cfg.port}
            }
          '';
        };
      };
    };
  };
}
