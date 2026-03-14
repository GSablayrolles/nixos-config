{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkOption mkIf;

  service = "authentik";
  cfg = config.homelab.services.authentik;
  homelab = config.homelab;
in
{

  options.homelab.services.${service} = {
    enable = mkEnableOption {
      description = "Enable ${service}";
    };

    domain = mkOption {
      type = lib.types.str;
      default = "login";
      description = "The domain for ${service}";
    };

    url = mkOption {
      type = lib.types.str;
      description = "URL of Authentik";
      default = "${cfg.domain}.${homelab.baseDomain}";
    };

    homepage = {
      name = mkOption {
        type = lib.types.str;
        default = "Authentik";
      };
      description = mkOption {
        type = lib.types.str;
        default = "Authentification and identity management";
      };
      icon = mkOption {
        type = lib.types.str;
        default = "authentik.svg";
      };
      category = mkOption {
        type = lib.types.str;
        default = "Auth";
      };
    };
  };

  config = mkIf cfg.enable {
    sops.secrets.authentik-env = {
      sopsFile = ../../secrets.yaml;
    };

    services.authentik =

      {
        enable = cfg.enable;
        environmentFile = config.sops.secrets.authentik-env.path;

        settings = {
          disable_startup_analytics = true;
          avatars = "initials";
        };
      };

    services.caddy.virtualHosts."${cfg.url}" = {
      useACMEHost = homelab.baseDomain;

      extraConfig = ''
        reverse_proxy http://localhost:9000
      '';
    };

    programs.nix-ld.enable = true;
  };

}
