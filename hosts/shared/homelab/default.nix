{
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkOption;
in
{

  options.homelab = {
    enable = mkEnableOption "The homelab services and configuration variables";

    baseDomain = mkOption {
      default = "";
      type = lib.types.str;
      description = ''
        Base domain for the homelab
      '';
    };
  };

  imports = [
    ./arr
    ./authentik
    ./caddy
    ./blocky
    ./homepage
    ./immich
    ./microbin
    ./minecraft
    ./miniflux
    ./stirling-pdf
    ./tailscale
  ];

}
