{
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkOption;
in
{
  imports = [
    ./microbin.nix
    ./caddy.nix
    ./stirling-pdf.nix
    ./blocky.nix
    ./homepage.nix
    ./miniflux.nix
    ./minecraft.nix
    ./authentik.nix
    # ./immich.nix
  ];

  options.homelab = {
    enable = lib.mkEnableOption "The homelab services and configuration variables";

    baseDomain = mkOption {
      default = "";
      type = lib.types.str;
      description = ''
        Base domain for the homelab
      '';
    };
  };

}
