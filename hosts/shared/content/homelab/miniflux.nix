{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  service = "miniflux";
  cfg = config.homelab.services.miniflux;
  homelab = config.homelab;
in
{
  options.homelab.services.${service} = {
    enable = mkEnableOption {
      description = "Enable ${service}";
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
        BASE_URL = "https://news.${homelab.baseDomain}";
        CREATE_ADMIN = 1;
        LISTEN_ADDR = "127.0.0.1:8070";
      };
    };

    services.caddy.virtualHosts."news.${homelab.baseDomain}" = {
      useACMEHost = homelab.baseDomain;

      extraConfig = ''
        reverse_proxy http://localhost:8070
      '';
    };
  };
}
