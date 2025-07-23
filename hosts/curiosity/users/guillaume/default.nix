{
  pkgs,
  config,
  ...
}:
{
  users = {
    users = {
      guillaume = {
        isNormalUser = true;
        description = "Guillaume";
        extraGroups = [
          "networkmanager"
          "wheel"
        ];
        shell = pkgs.zsh;
        initialPassword = "tmp10";
        home = "/home/guillaume";
      };
    };
  };

}
