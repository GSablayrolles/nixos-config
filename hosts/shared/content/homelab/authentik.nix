{
  config,
  pkgs,
  inputs,
  ...
}:
let
  baseDomain = config.homelab.baseDomain;
in
{

  sops.secrets.authentik-env = {
    sopsFile = ../../secrets.yaml;
  };

  services.authentik =
    # let
    #   customAuthentikScope = inputs.authentik-nix.lib.mkAuthentikScope {
    #     inherit pkgs;
    #   };

    #   # Override the scope to change gopkgs
    #   overriddenScope = customAuthentikScope.overrideScope (
    #     final: prev: {
    #       authentikComponents = prev.authentikComponents // {
    #         gopkgs = prev.authentikComponents.gopkgs.override {
    #           buildGo124Module = pkgs.buildGo125Module;
    #         };
    #       };
    #     }
    #   );
    # in
    {
      enable = true;
      environmentFile = config.sops.secrets.authentik-env.path;

      #   inherit (overriddenScope) authentikComponents;

      settings = {
        disable_startup_analytics = true;
        avatars = "initials";
      };
    };

  services.caddy.virtualHosts."login.${baseDomain}" = {
    useACMEHost = baseDomain;

    extraConfig = ''
      reverse_proxy http://localhost:9000
    '';
  };

  programs.nix-ld.enable = true;

}
