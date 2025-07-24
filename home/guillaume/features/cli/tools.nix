{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.home-config.cli;
in
{

  home.packages = mkIf cfg.tools.enable (
    with pkgs;
    [
      pfetch
      neofetch
      pipes
      obsidian
    ]
  );

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
  };
}
