{ config, ... }:
{
  homelab = {
    enable = true;
    baseDomain = config.networking.domain;

    services = {
      homepage.enable = true;

      authentik.enable = true;

      tailscale.enable = true;

      portfolio.enable = false;

      actual.enable = true;

      microbin.enable = true;

      yarr = {
        enable = true;
      };

      miniflux = {
        enable = false;
      };

      stirling-pdf = {
        enable = true;
        domain = "spdf";
      };

      immich = {
        enable = true;
        domain = "immich";
      };

      nixarr = {
        enable = true;

        bazarr.enable = true;
        prowlarr.enable = true;
        radarr.enable = true;
        sonarr.enable = true;

        sabnzbd.enable = true;

        shelfmark.enable = true;

        jellyfin.enable = true;
        jellyseerr.enable = true;

      };
    };
  };
}
