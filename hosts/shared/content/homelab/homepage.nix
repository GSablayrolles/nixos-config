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
          Utilities = {
            header = false;
            style = "row";
            columns = 2;

            Calendar = {
              header = false;

            };

            Services = {
              header = true;
              style = "row";
              columns = 3;
            };
          };

        }

      ];
      headerStyle = "boxed";
      hideVersion = true;

      background = {
        image = " https://images.unsplash.com/photo-1502790671504-542ad42d5189?auto=format&fit=crop&w=2560&q=80";
        blur = "sm"; # sm, "", md, xl... see https://tailwindcss.com/docs/backdrop-blur
        saturate = 50; # 0, 50, 100... see https=//tailwindcss.com/docs/backdrop-saturate
        brightness = 50; # 0, 50, 75... see https=//tailwindcss.com/docs/backdrop-brightness
        opacity = 50; # 0-100};
      };
      cardBlur = "xs"; # xs, md, etc... see https://tailwindcss.com/docs/backdrop-blur

      color = "slate";
      theme = "dark";

      statusStyle = "dot";
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
      {
        greeting = {
          textSize = "2xl";
          text = "Ferrets Lover";
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
        Utilities = [
          {
            Calendar = [
              {
                "Our Calendar" = {
                  widget = {
                    type = "calendar";
                    view = "monthly"; # optional - possible values monthly, agenda
                    maxEvents = 10; # optional - defaults to 10
                    showTime = true; # optional - show time for event happening today - defaults to false
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
                  icon = "microbin.webp";
                  siteMonitor = "https://mc.${baseDomain}";

                };
              }
              {
                "Stirling-pdf" = {
                  href = "https://spdf.${baseDomain}";
                  description = "PDF operations service";
                  icon = "stirling-pdf.svg";
                  siteMonitor = "https://spdf.${baseDomain}";

                };
              }
              {
                Miniflux = {
                  href = "https://news.${baseDomain}";
                  description = "Personnal RSS feed";
                  icon = "miniflux-light.svg";
                  siteMonitor = "https://news.${baseDomain}";

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
          {
            Monitor = [

              {
                Minecraft = {
                  widget = {
                    type = "minecraft";
                    url = "udp://127.0.0.1:25565";
                  };
                };
              }
            ];

          }
        ];
      }
    ];

    bookmarks = [
      {
        Personnal = [
          {
            Github = [
              {
                abbr = "GH";
                icon = "github.svg";
                href = "https://github.com/GSablayrolles";
                description = "My GitHub";
              }
            ];
          }
          {
            ProtonMail = [
              {
                abbr = "PM";
                icon = "proton-mail.svg";
                href = "https://mail.proton.me/u/2/inbox";
              }
            ];
          }
        ];
      }
      {
        Entertainment = [
          {
            YouTube = [
              {
                abbr = "YT";
                icon = "youtube.svg";
                href = "https://youtube.com/";
              }
            ];
          }
        ];
      }
      {
        Ferrets = [
          {
            CFAF = [
              {
                abbr = "CF";
                icon = "otter-wiki.svg";
                href = "https://club-furet.fr/";
              }
            ];
          }
        ];
      }
    ];
  };

  services.caddy.virtualHosts."${baseDomain}" = {
    useACMEHost = baseDomain;

    extraConfig = ''
      reverse_proxy http://localhost:8082
    '';
  };
}
