{ config, ... }:
let
  baseDomain = config.homelab.baseDomain;
in
{

  services.glances.enable = true;
  services.homepage-dashboard = {
    enable = true;
    environmentFile = builtins.toFile "homepage.env" "HOMEPAGE_ALLOWED_HOSTS=${baseDomain}";

    settings = {
      layout = [
        {
          Glances = {
            header = false;
            style = "row";
            columns = 4;
          };
        }
        {
          Services = {
            header = true;
            style = "row";
          };
        }
      ];
      headerStyle = "boxed";
      hideVersion = true;

      color = "slate";
      theme = "dark";
    };

    widgets = [
      {
        openmeteo = {
          label = "Toulouse";
          latitude = 43.6;
          longitude = 1.43;
          timezone = "Europe/Paris";
          units = "metric";
          cache = 10;
        };
      }
    ];

    services = [
      {
        # Group
        Glances =
          let
            port = toString config.services.glances.port;
          in
          # Services of Group Glances
          [
            {
              Info = {
                widget = {
                  type = "glances";
                  url = "http://localhost:${port}";
                  metric = "info";
                  chart = true;
                  version = 4;
                };
              };
            }
            {
              "CPU Temp" = {
                widget = {
                  type = "glances";
                  url = "http://localhost:${port}";
                  metric = "sensor:Package id 0";
                  chart = true;
                  version = 4;
                };
              };
            }
            {
              Processes = {
                widget = {
                  type = "glances";
                  url = "http://localhost:${port}";
                  metric = "process";
                  chart = true;
                  version = 4;
                };
              };
            }
            {
              Network = {
                widget = {
                  type = "glances";
                  url = "http://localhost:${port}";
                  metric = "network:wlp2s0";
                  chart = true;
                  version = 4;
                };
              };
            }
          ];
      }
      {
        Services = [
          {
            Microbin = {
              href = "https://mc.${baseDomain}";
              description = "Minimalist copy/paste service";
              icon = "microbin.png";
            };
          }
          {
            "Stirling-pdf" = {
              href = "https://spdf.${baseDomain}";
              description = "PDF operations service";
              icon = "stirling-pdf.png";
            };
          }
          #   {
          #     Immich = {
          #       href = "https://photos.${baseDomain}";
          #       description = "Self hosting alternative to Google Photos";
          #       icon = "immich.svg";
          #     };
          #   }
        ];
      }
    ];
  };
}
