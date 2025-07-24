{ lib, ... }:
let
  inherit (lib) mkEnableOption mkOption;
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

    desktop = {
      wayland = {

        enable = mkEnableOption ''Enable Wayland Window Manager'';

        hyprland = {
          enable = mkEnableOption ''
            Enable Hyprland
          '';
          nvidia = mkOption {
            type = lib.types.bool;
            default = false;
            description = ''
              Enable Nvidia options for Hyprland
            '';
          };
        };

        waybarConfig = {
          batteryName = mkOption {
            type = lib.types.string;
            default = "BAT0";
            description = "Battery filename as in /sys/class/powwer_supply/BATx";
          };
        };
      };

      gnome.enable = mkEnableOption ''
        Enable Gnome
      '';

      stylix.enable = mkEnableOption ''
        Enable stylix (if enabled in NixOS config)
      '';
    };

    dev = {
      vscode.enable = mkEnableOption "Enable vscode";
    };
  };
}
