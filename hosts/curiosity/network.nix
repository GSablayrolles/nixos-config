{
  config,
  lib,
  pkgs,
  ...
}:
{
  networking = {
    hostName = "curiosity";

    domain = "ferrets-home.party";
    search = [ "ferrets-home.party" ];

    extraHosts = ''
      192.168.1.46 iss
    '';

    nameservers = [
      "192.168.1.46"
      "192.168.1.254"
    ];

    networkmanager.dns = lib.mkForce "none";

    firewall = {
      enable = true;
    };
  };

  sops.secrets.tailscale-key = {
    sopsFile = ../shared/secrets.yaml;
  };

  environment.systemPackages = with pkgs; [
    tailscale
  ];

  networking.firewall = {
    trustedInterfaces = [ "tailscale0" ];
  };

  services = {
    tailscale = {
      enable = true;
      port = 41641;
      authKeyFile = config.sops.secrets.tailscale-key.path;
      extraSetFlags = [ "--netfilter-mode=nodivert" ];
    };
  };

}
