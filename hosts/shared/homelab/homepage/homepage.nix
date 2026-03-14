{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  service = "homepage-dashboard";
  homelab = config.homelab;
  homepage = config.homelab.services.homepage;
  nixarr = config.homelab.services.nixarr;
in
{
  options.homelab.services.homepage = {
    enable = mkEnableOption {
      description = "Enable ${service}";
    };
  };

  config = mkIf homepage.enable {
    services.glances.enable = true;

    services.homepage-dashboard = {
      enable = true;
      environmentFiles = [
        (builtins.toFile "homepage.env" "HOMEPAGE_ALLOWED_HOSTS=${homelab.baseDomain}")
      ];

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
              header = false;
              style = "row";
              columns = 3;

              Media = {
                header = false;
              };

              Auth = {
                header = false;
              };

              Apps = {
                header = false;
              };
            };
          }
          {
            Downloads = {
              header = false;
              style = "row";
              columns = 2;

              Calendar = {
                header = false;
              };

              Arrs = {
                header = false;
              };
            };
          }
        ];

        background = {
          image = "https://server.wallpaperalchemy.com/storage/wallpapers/91/4k-black-hole-minimalistic-wallpaper.png";
          blur = "md";
          saturate = 80;
          brightness = 50;
          opacity = 30;
        };

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
          datetime = {
            textSize = "2xl";
            format = {
              timeStyle = "short";
              hourCycle = "h24";
              timeZone = "Europe/Paris";
            };
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
                    metric = "network:enp3s0f1";
                    chart = true;
                    version = 4;
                  };
                };
              }
            ];
        }
        {
          Services =
            let
              homepageCategories = [
                "Media"
                "Auth"
                "Apps"
              ];
              hl = config.homelab.services;
              servicesByCategory =
                cat: servicesRoot:
                (lib.attrsets.filterAttrs (
                  _name: value: value ? homepage && value.homepage.category == cat
                ) servicesRoot);
              displayService = servicesRoot: service: {
                "${servicesRoot.${service}.homepage.name}" = {
                  icon = servicesRoot.${service}.homepage.icon;
                  description = servicesRoot.${service}.homepage.description;
                  href = "https://${servicesRoot.${service}.url}";
                  siteMonitor = "https://${servicesRoot.${service}.url}";
                };
              };
              applyCategoryDisplayService =
                cat: servicesRoot:
                lib.lists.forEach (lib.attrsets.mapAttrsToList (name: _value: name) (
                  servicesByCategory "${cat}" servicesRoot
                )) (service: displayService servicesRoot service);

            in
            lib.lists.forEach homepageCategories (cat: {
              "${cat}" = applyCategoryDisplayService cat hl ++ applyCategoryDisplayService cat nixarr;
            });
        }
        {
          Downloads = [
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
              Arrs = [
                {
                  Radarr = {
                    href = "https://${nixarr.radarr.url}";
                    description = "Download our movies";
                    icon = "radarr.webp";
                    siteMonitor = "https://${nixarr.radarr.url}";

                  };
                }
                {
                  Sonarr = {
                    href = "https://${nixarr.sonarr.url}";
                    description = "Download our series";
                    icon = "sonarr.webp";
                    siteMonitor = "https://${nixarr.sonarr.url}";

                  };
                }
                {
                  Bazarr = {
                    href = "https://${nixarr.bazarr.url}";
                    description = "Download our subtitles";
                    icon = "bazarr.webp";
                    siteMonitor = "https://${nixarr.bazarr.url}";

                  };
                }
                {
                  Prowlarr = {
                    href = "https://${nixarr.prowlarr.url}";
                    icon = "prowlarr.webp";
                    siteMonitor = "https://${nixarr.prowlarr.url}";
                  };
                }
                {
                  Sabnzbd = {
                    href = "https://${nixarr.sabnzbd.url}";
                    icon = "sabnzbd.webp";
                    siteMonitor = "https://${nixarr.sabnzbd.url}";
                  };
                }
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
                  description = "My ProtonMail";
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
