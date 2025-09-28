{ config, ... }:
{
  homelab = {
    enable = true;
    baseDomain = config.networking.domain;

    services = {
      homepage.enable = true;
      microbin.enable = true;
      miniflux.enable = true;
      stirling-pdf.enable = true;
    };
  };
}
