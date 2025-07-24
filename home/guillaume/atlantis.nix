{ ... }:

{
  imports = [
    ./shared
    ./features
  ];

  home-config = {
    apps = {
      brave.enable = true;
    };

    cli = {
      yazi.enable = true;
      tools.enable = true;
    };
  };

  monitors = [
    {
      name = "HDMI-A-1";
      width = 1920;
      height = 1080;
      x = 0;
      workspace = "1";
      refreshRate = 75;
    }
    {
      name = "DP-1";
      width = 1920;
      height = 1080;
      x = 1920;
      workspace = "2";
      primary = true;
      refreshRate = 120;
    }
  ];
}
