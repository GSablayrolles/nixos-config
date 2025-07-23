{
  pkgs,
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
        home = "/home/guillaume";

      };
    };
  };

}
