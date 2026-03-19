{
  lib,
  ...
}:
{
  networking = {
    hostName = "atlantis";

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

}
