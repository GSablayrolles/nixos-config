{ lib, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  options.home-config = {
    apps = {
      brave.enable = mkEnableOption "Enable Brave";
    };

    cli = {
      yazi.enable = mkEnableOption "Enable Yazi";
      tools.enable = mkEnableOption "Enable terminal tools";
    };
  };
}
