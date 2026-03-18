{ ... }:
{
  networking = {
    hostName = "iss";

    domain = "ferrets-home.party";
    search = [ "ferrets-home.party" ];

    networkmanager = {
      unmanaged = [ "wlp2s0" ];
      wifi.powersave = false;
    };

    interfaces = {
      enp3s0f1 = {
        useDHCP = false;
        ipv4.addresses = [
          {
            address = "192.168.1.46";
            prefixLength = 24;
          }
        ];
      };
    };

    firewall = {
      enable = true;

      allowedUDPPorts = [ 53 ];
    };
  };

}
