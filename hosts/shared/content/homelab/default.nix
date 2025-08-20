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
    # ./immich.nix
  ];

  options.homelab = {
    baseDomain = mkOption {
      default = "ferrets-home.party";
      type = lib.types.string;
      description = ''
        Base domain for the homelab
      '';
    };
  };

}
