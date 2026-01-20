{ config, ... }:
{
  homelab = {
    enable = true;
    baseDomain = config.networking.domain;

    services = {
      homepage.enable = true;

      microbin = {
        enable = true;
        domain = "mc";
      };

      miniflux = {
        enable = true;
        domain = "news";
      };

      stirling-pdf = {
        enable = true;
        domain = "spdf";
      };

      immich = {
        enable = true;
        domain = "photos";
      };
    };
  };
}
