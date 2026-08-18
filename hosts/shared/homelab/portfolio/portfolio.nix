{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  inherit (lib) mkEnableOption mkOption mkIf;

  service = "portfolio";
  cfg = config.homelab.services.portfolio;
  homelab = config.homelab;

  system = pkgs.stdenv.hostPlatform.system;
  portfolioSite = inputs.portfolio.packages.${system}.default;
in
{
  options.homelab.services.${service} = {
    enable = mkEnableOption {
      description = "Enable ${service}";
    };

    domain = mkOption {
      type = lib.types.str;
      default = "guillaume";
      description = "The domain for ${service}";
    };

    url = mkOption {
      type = lib.types.str;
      description = "URL of the Portfolio";
      default = "${cfg.domain}.${homelab.baseDomain}";
    };

  };

  config = mkIf cfg.enable {

    # To tunnels through
    services.caddy.virtualHosts."${cfg.url}" = {
      useACMEHost = homelab.baseDomain;

      extraConfig = ''
        bind 127.0.0.1 
        root ${portfolioSite}
        file_server
      '';
    };

    # Local access
    services.caddy.virtualHosts."guillaume-int.ferrets-home.party" = {
      useACMEHost = homelab.baseDomain;

      extraConfig = ''
        root ${portfolioSite}
        file_server
      '';
    };

    sops.secrets."cloudflared-tunnels-portfolio" = {
      sopsFile = ../../secrets.yaml;
    };

    services.cloudflared = {
      tunnels."08f018fc-756b-4e10-a039-394832ef8700" = {
        credentialsFile = config.sops.secrets."cloudflared-tunnels-portfolio".path;
        default = "http_status:404";

        ingress = {
          "guillaume.ferrets-home.party" = {
            service = "https://127.0.0.1:443";
            originRequest = {
              originServerName = "guillaume.ferrets-home.party";
              httpHostHeader = "guillaume.ferrets-home.party";
            };
          };
        };
      };
    };
  };
}
