{
  config,
  ...
}:
let
  baseDomain = config.homelab.baseDomain;
in
{
  services.microbin = {
    enable = true;
    settings = {
      MICROBIN_WIDE = true;
      MICROBIN_MAX_FILE_SIZE_UNENCRYPTED_MB = 2048;
      #   MICROBIN_PUBLIC_PATH = "https://${cfg.url}/";
      MICROBIN_BIND = "127.0.0.1";
      MICROBIN_PORT = 8069;
      MICROBIN_HIDE_LOGO = true;
      MICROBIN_HIGHLIGHTSYNTAX = true;
      MICROBIN_HIDE_HEADER = true;
      MICROBIN_HIDE_FOOTER = true;
    };
  };

  services.caddy.virtualHosts."mc.${baseDomain}" = {
    useACMEHost = baseDomain;

    extraConfig = ''
      reverse_proxy http://${config.services.microbin.settings.MICROBIN_BIND}:${toString config.services.microbin.settings.MICROBIN_PORT}
    '';
  };
}
