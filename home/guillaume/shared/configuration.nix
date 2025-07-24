{ lib, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  options.home-config = {
    cli = {
      yazi.enable = mkEnableOption ''
        Enable Yazi
      '';

    };
  };
}
