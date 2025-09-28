{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  service = "stirling-pdf";
  cfg = config.homelab.services.stirling-pdf;
  homelab = config.homelab;
in
{
  options.homelab.services.${service} = {
    enable = mkEnableOption {
      description = "Enable ${service}";
    };
  };

  config = mkIf cfg.enable {
    services.stirling-pdf = {
      enable = true;
      environment = {
        SERVER_PORT = 8060;
      };
    };

    services.caddy.virtualHosts."spdf.${homelab.baseDomain}" = {
      useACMEHost = homelab.baseDomain;

      extraConfig = ''
        reverse_proxy http://127.0.0.1:8060
      '';
    };
  };
}
