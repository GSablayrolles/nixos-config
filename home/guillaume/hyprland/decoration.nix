{config, lib, ...}: 
{
    wayland.windowManager.hyprland.settings = {
         general = {
                gaps_out = 5;
            };

            decoration = {
                rounding = 5;
            };

    };
}