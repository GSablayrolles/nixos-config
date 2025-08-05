{ config, ... }:
{
  services.openssh = {
    enable = true;
    ports = [ 22 ];
    allowSFTP = true;

    settings = {
      PasswordAuthentication = false;
      X11Forwarding = false;
      KbdInteractiveAuthentication = false;
    };
  };

  services.fail2ban = {
    enable = true;
    maxretry = 10;
    bantime = "24h";
    bantime-increment.enable = true;
  };

}
