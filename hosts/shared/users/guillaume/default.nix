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

        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIObfz/cNl1b0y7ONYYoYQO0CYDs7pFnwjsnSZz8MtvPX g.sablayrolles@proton.me"
        ];

        initialPassword = "tmp10";
      };
    };
  };

}
