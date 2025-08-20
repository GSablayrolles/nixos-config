{
  config,
  ...
}:
let
  baseDomain = config.homelab.baseDomain;
in
{
  services.stirling-pdf = {
    enable = true;
    environment = {
      SERVER_PORT = 8060;
    };
  };

  services.caddy.virtualHosts."spdf.${baseDomain}" = {
    useACMEHost = baseDomain;

    extraConfig = ''
      reverse_proxy http://127.0.0.1:8060
    '';
  };
}
