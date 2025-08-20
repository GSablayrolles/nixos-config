{ pkgs, config, ... }:
let
  baseDomain = config.homelab.baseDomain;
in

{

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  sops.secrets.cloudflare-token = {
    sopsFile = ../../secrets.yaml;
    owner = config.services.caddy.user;
    group = config.services.caddy.group;
  };

  services.caddy = {
    enable = true;
    globalConfig = ''
      auto_https off
    '';

    virtualHosts = {
      "http://${baseDomain}" = {
        extraConfig = ''
          redir https://{host}{uri}
        '';
      };
      "http://*.${baseDomain}" = {
        extraConfig = ''
          redir https://{host}{uri}
        '';
      };

      "${baseDomain}" = {
        useACMEHost = baseDomain;

        extraConfig = ''
          reverse_proxy http://localhost:8082
        '';
      };

      "mc.${baseDomain}" = {
        useACMEHost = baseDomain;

        extraConfig = ''
          reverse_proxy http://127.0.0.1:8069
        '';
      };

      "localhost".extraConfig = ''
        respond "OK"
      '';
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "g.sablayrolles@proton.me";

    certs."${baseDomain}" = {
      group = config.services.caddy.group;
      reloadServices = [ "caddy.service" ];
      domain = "${baseDomain}";
      extraDomainNames = [ "*.${baseDomain}" ];
      dnsProvider = "cloudflare";
      dnsResolver = "1.1.1.1:53";
      dnsPropagationCheck = true;
      environmentFile = config.sops.secrets.cloudflare-token.path;
    };
  };

}
