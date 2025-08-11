{ pkgs, config, ... }:
{
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  services.caddy = {
    enable = true;
    virtualHosts."ferret.party".extraConfig = ''
      reverse_proxy http://localhost:8082

      tls internal
    '';
  };
}
