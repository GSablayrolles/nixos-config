{
  ...
}:
{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Guillaume Sablayrolles";
        email = "g.sablayrolles@proton.me";
      };
      credential.helper = "store";
    };
  };
}
