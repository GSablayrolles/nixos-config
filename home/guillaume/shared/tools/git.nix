{
  ...
}:
{
  programs.git = {
    enable = true;
    userName = "Guillaume Sablayrolles";
    userEmail = "g.sablayrolles@proton.me";
    extraConfig = {
      credential.helper = "store";
    };
  };
}
