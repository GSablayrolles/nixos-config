{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  service = "homepage-dashboard";
  cfg = config.homelab.services.homepage;
  homelab = config.homelab;
in
{
  options.homelab.services.homepage = {
    enable = mkEnableOption {
      description = "Enable ${service}";
    };
  };

  config = mkIf cfg.enable {
    services.glances.enable = true;
    services.homepage-dashboard = {
      enable = true;
      environmentFile = builtins.toFile "homepage.env" "HOMEPAGE_ALLOWED_HOSTS=${homelab.baseDomain}";

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

        background = {
          image = ./homepage_bg.avif;
          blur = "sm"; # sm, "", md, xl... see https://tailwindcss.com/docs/backdrop-blur
          saturate = 50; # 0, 50, 100... see https=//tailwindcss.com/docs/backdrop-saturate
          brightness = 50; # 0, 50, 75... see https=//tailwindcss.com/docs/backdrop-brightness
          opacity = 50; # 0-100};
        };
        cardBlur = "xs"; # xs, md, etc... see https://tailwindcss.com/docs/backdrop-blur

        color = "slate";
        theme = "dark";

        headerStyle = "boxed";
        hideVersion = true;

        statusStyle = "dot";
      };

      widgets = [
        {
          greeting = {
            textSize = "2xl";
            text = "Ferrets Lover";
          };
        }
        {
          search = {
            provider = "brave";
            focus = false;
            showSearchSuggestions = true;

          };
        }
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
                    href = "https://mc.${homelab.baseDomain}";
                    description = "Minimalist copy/paste service";
                    icon = "microbin.webp";
                    siteMonitor = "https://mc.${homelab.baseDomain}";

                  };
                }
                {
                  "Stirling-pdf" = {
                    href = "https://spdf.${homelab.baseDomain}";
                    description = "PDF operations service";
                    icon = "stirling-pdf.svg";
                    siteMonitor = "https://spdf.${homelab.baseDomain}";

                  };
                }
                {
                  Miniflux = {
                    href = "https://news.${homelab.baseDomain}";
                    description = "Personnal RSS feed";
                    icon = "miniflux-light.svg";
                    siteMonitor = "https://news.${homelab.baseDomain}";

                  };
                }
                {
                  Authentik = {
                    href = "https://login.${homelab.baseDomain}";
                    description = "Authentification and identity management";
                    icon = "authentik.svg";
                    siteMonitor = "https://login.${homelab.baseDomain}";

                  };
                }
                #   {
                #     Immich = {
                #       href = "https://photos.${homelab.baseDomain}";
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

    services.caddy.virtualHosts."${homelab.baseDomain}" = {
      useACMEHost = homelab.baseDomain;

      extraConfig = ''
        route {
            reverse_proxy /outpost.goauthentik.io/* http://outpost.${homelab.baseDomain}:9000

            forward_auth http://outpost.${homelab.baseDomain}:9000 {
                uri /outpost.goauthentik.io/auth/caddy

                copy_headers X-Authentik-Username X-Authentik-Groups X-Authentik-Entitlements X-Authentik-Email X-Authentik-Name X-Authentik-Uid X-Authentik-Jwt X-Authentik-Meta-Jwks X-Authentik-Meta-Outpost X-Authentik-Meta-Provider X-Authentik-Meta-App X-Authentik-Meta-Version

                trusted_proxies private_ranges
            }

            reverse_proxy http://localhost:8082
        }
      '';
    };
  };
}
