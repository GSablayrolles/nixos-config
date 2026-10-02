{ ... }:

{
  programs.starship = {
    enable = true;
    # Configuration written to ~/.config/starship.toml
    enableZshIntegration = true;
    settings = {
      format = "$all";

      username = {
        show_always = true;
        format = "[$user@](green)";
      };

      hostname = {
        disabled = false;
        format = "[$hostname](green) ";
        ssh_only = false;
      };

      character = {
        success_symbol = "[❯](bold blue)";
        error_symbol = "[❮](bold red)";
      };

    };
  };
}
