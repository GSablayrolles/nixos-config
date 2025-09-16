{ inputs, config, ... }:
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  sops = {
    defaultSopsFile = ../shared/secrets.yaml;
    defaultSopsFormat = "yaml";

    age.keyFile = "${config.users.users.guillaume.home}/.config/sops/age/keys.txt";

  };

}
