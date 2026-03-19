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

  imports = [
    ./fastfetch
  ];

  home.packages = mkIf cfg.tools.enable (
    with pkgs;
    [
      pfetch
      fastfetch
      pipes
      obsidian
      bat
      wget
      discord
      sops
    ]
  );

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
  };
}
