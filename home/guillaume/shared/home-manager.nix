{
  ...
}:
{
  home = {
    username = "guillaume";
    homeDirectory = "/home/guillaume";
  };

  home.sessionVariables._THEME = "marwaita-pop_os";
  home.sessionVariables.TERMINAL = "kitty";

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };
  programs.home-manager.enable = true;
  home.stateVersion = "24.05";
}
