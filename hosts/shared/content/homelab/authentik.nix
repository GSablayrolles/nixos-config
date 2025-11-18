{
  config,
  ...
}:
let
  baseDomain = config.homelab.baseDomain;
in
{

  sops.secrets.authentik-env = {
    sopsFile = ../../secrets.yaml;
  };

  services.authentik = {
    enable = true;
    environmentFile = config.sops.secrets.authentik-env.path;

    settings = {
      disable_startup_analytics = true;
      avatars = "initials";
    };
  };

  services.caddy.virtualHosts."login.${baseDomain}" = {
    useACMEHost = baseDomain;

    extraConfig = ''
      reverse_proxy http://localhost:9000
    '';
  };

  programs.nix-ld.enable = true;

}
