{
  config,
  lib,
  ...
}:
{
  services.glances.enable = true;
  services.homepage-dashboard = {
    enable = true;
    environmentFile = builtins.toFile "homepage.env" "HOMEPAGE_ALLOWED_HOSTS=ferret.party";

    # customCSS = ''
    #   body, html {
    #     font-family: SF Pro Display, Helvetica, Arial, sans-serif !important;
    #   }
    #   .font-medium {
    #     font-weight: 700 !important;
    #   }
    #   .font-light {
    #     font-weight: 500 !important;
    #   }
    #   .font-thin {
    #     font-weight: 400 !important;
    #   }
    #   #information-widgets {
    #     padding-left: 1.5rem;
    #     padding-right: 1.5rem;
    #   }
    #   div#footer {
    #     display: none;
    #   }
    #   .services-group.basis-full.flex-1.px-1.-my-1 {
    #     padding-bottom: 3rem;
    #   };
    # '';
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
      headerStyle = "clean";
      hideVersion = true;
    };

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
            Test = {
              href = "http://localhost:61208";
            };
          }
        ];
      }
    ];
  };
}
