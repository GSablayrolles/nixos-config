{ config, ... }:
let
  baseDomain = config.homelab.baseDomain;
in
{
  sops.secrets.miniflux-creds = {
    sopsFile = ../../secrets.yaml;
  };

  services.miniflux = {
    enable = true;
    adminCredentialsFile = config.sops.secrets.miniflux-creds.path;
    config = {
      BASE_URL = "https://news.${baseDomain}";
      CREATE_ADMIN = 1;
      LISTEN_ADDR = "127.0.0.1:8070";
    };
  };

  services.caddy.virtualHosts."news.${baseDomain}" = {
    useACMEHost = baseDomain;

    extraConfig = ''
      reverse_proxy http://localhost:8070
    '';
  };
}
