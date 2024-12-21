self: {
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkMerge types;
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkOption mkEnableOption;

  package = self.packages.${pkgs.system}.default;
  cfg = config.programs.cassiopea;
in {
  options.programs.cassiopea = {
    enable = mkEnableOption "Cassiopea wayland shell";
    avatar_path = mkOption {
      type = types.str;
      example = "/home/giu/.dotfiles/assets/avatar.png";
      description = ''
        Set environment variable to the path of the avatar image.
      '';
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      home.packages = [package];
    }

    (mkIf (cfg.avatar_path != null && cfg.avatar_path != "") {
      home.sessionVariables = {
        CASSIOPEA_AVATAR_PATH = config.programs.cassiopea.avatar_path;
      };
    })
  ]);
}
