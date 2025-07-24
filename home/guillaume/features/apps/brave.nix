{ config, ... }:
let
  inherit (config.home-config.cli.yazi) enable;
in
{
  programs.brave = {
    inherit enable;
  };
}
