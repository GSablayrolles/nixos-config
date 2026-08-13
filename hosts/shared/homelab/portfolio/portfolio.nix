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

    services.caddy.virtualHosts."${cfg.url}" = {
      useACMEHost = homelab.baseDomain;

      extraConfig = ''
        root ${portfolioSite}
        file_server
      '';
    };
  };
}
