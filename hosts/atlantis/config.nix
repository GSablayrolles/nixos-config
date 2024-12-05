{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  nixpkgs = {
    overlays = [];
    config = {
      allowUnfree = true;
    };
  };

  networking.networkmanager.enable = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  programs.zsh.enable = true;

  console.keyMap = "fr";
  services.printing.enable = true;

  hardware.pulseaudio.enable = false;
  
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.libinput.enable = true;

  environment.systemPackages = with pkgs; [vim];
  services.blueman.enable = true;

  # Hyprland
  programs.hyprland.enable = true;

  system.stateVersion = "24.11";
}
