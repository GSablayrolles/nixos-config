{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  service = "nixarr";
  cfg = config.homelab.services.nixarr;
in
{

  options.homelab.services.nixarr = {
    enable = mkEnableOption {
      description = "Enable ${service}";
    };
  };

  config = mkIf cfg.enable {
    nixarr = {
      enable = cfg.enable;

    };
  };

  imports = [
    ./arrs
    ./jellys
    ./sabnzbd
  ];
}
