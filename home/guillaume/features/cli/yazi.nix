{
  config,
  ...
}:
let
  inherit (config.home-config.cli.yazi) enable;
in
{
  programs.yazi = {
    inherit enable;
    enableFishIntegration = true;

    settings = {
      mgr = {
        sort_by = "natural";
        show_hidden = true;
        ratio = [
          1
          3
          4
        ];
        linemode = "mtime";
      };

      opener = {
        edit = [
          {
            run = ''code "$@"'';
            desc = "code";
            block = true;
            fort = "unix";
            orphan = true;
          }
        ];
      };
    };
  };
}
