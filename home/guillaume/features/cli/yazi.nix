{
  config,
  ...
}:
let
  inherit (config.home-config.cli.yazi) enable;
in
{
  programs.yazi = {
    inherit enable;
    enableFishIntegration = true;
  };
}
