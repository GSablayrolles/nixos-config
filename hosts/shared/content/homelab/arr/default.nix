{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkOption mkIf;

  service = "nixarr";
  cfg = config.homelab.services.nixarr;
  homelab = config.homelab;
in
{

  options.homelab.services.nixarr = {
    enable = mkEnableOption {
      description = "Enable ${service}";
    };

    bazarr = {
      enable = mkEnableOption {
        description = "Enable Bazarr";
      };

      port = mkOption {
        description = "Port for Bazarr";
        default = 6767;
      };
    };

    prowlarr = {
      enable = mkEnableOption {
        description = "Enable Prowlarr";
      };

      port = mkOption {
        description = "Port for Prowlarr";
        default = 9696;
      };
    };

    radarr = {
      enable = mkEnableOption {
        description = "Enable Radarr";
      };

      port = mkOption {
        description = "Port for Radarr";
        default = 7878;
      };
    };

    sonarr = {
      enable = mkEnableOption {
        description = "Enable Sonarr";
      };

      port = mkOption {
        description = "Port for Sonarr";
        default = 8989;
      };
    };

    recyclarr = {
      enable = mkEnableOption {
        description = "Enable Recyclarr";
      };
    };

    jellyfin = {
      enable = mkEnableOption {
        description = "Enable Jellyfin";
      };
    };

    jellyseerr = {
      enable = mkEnableOption {
        description = "Enable Jellyseerr";
      };

      port = mkOption {
        description = "Port for Jellyseer";
        default = 5055;
      };
    };
  };

  config = mkIf cfg.enable {
    nixarr = {
      enable = cfg.enable;

      jellyfin = {
        enable = cfg.jellyfin.enable;
      };

      jellyseerr = {
        enable = cfg.jellyseerr.enable;
        port = cfg.jellyseerr.port;
      };

      bazarr = {
        enable = cfg.bazarr.enable;
        port = cfg.bazarr.port;
      };

      prowlarr = {
        enable = cfg.prowlarr.enable;
        port = cfg.prowlarr.port;
      };

      radarr = {
        enable = cfg.radarr.enable;
        port = cfg.radarr.port;
      };

      sonarr = {
        enable = cfg.sonarr.enable;
        port = cfg.sonarr.port;
      };

      recyclarr.enable = cfg.recyclarr.enable;

    };
  };
}
