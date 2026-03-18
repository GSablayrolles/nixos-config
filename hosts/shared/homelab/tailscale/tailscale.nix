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
    };

    services = {
      tailscale = {
        enable = true;
        port = cfg.port;
        authKeyFile = config.sops.secrets.tailscale-key.path;
        extraSetFlags = [ "--netfilter-mode=nodivert" ];
      };
    };
  };
}
