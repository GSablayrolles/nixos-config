{ config, ... }:
{

  sops.secrets.ssh-host-key = {
    sopsFile = ../secrets.yaml;
    owner = "guillaume";
    neededForUsers = true;
  };

  services.openssh = {
    enable = true;
    ports = [ 22 ];
    allowSFTP = true;

    settings = {
      PasswordAuthentication = false;
      X11Forwarding = false;
      KbdInteractiveAuthentication = false;
    };

    hostKeys = [
      {
        inherit (config.sops.secrets.ssh-host-key) path;
        type = "ed25519";
      }
    ];
  };

  services.fail2ban = {
    enable = true;
    maxretry = 10;
    bantime = "24h";
    bantime-increment.enable = true;
  };

}
