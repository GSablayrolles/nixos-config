{
  config,
  ...
}:
let
  baseDomain = config.homelab.baseDomain;
in
{
  services.blocky = {
    enable = true;
    settings = {
      ports.dns = 53;
      upstreams.groups.default = [ "1.1.1.1" ];
      bootstrapDns = {
        upstream = "1.1.1.1";
        ips = [ "1.1.1.1" ];
      };
      customDNS = {
        customTTL = "1h";
        filterUnmappedTypes = true;
        mapping = {
          "${baseDomain}" = "192.168.1.46";
        };
      };
    };
  };

  networking.nameservers = [ "192.168.1.46" ];
  networking.networkmanager.dns = "none";
}
