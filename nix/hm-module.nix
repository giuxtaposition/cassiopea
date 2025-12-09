self: {
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkMerge;
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;

  package = self.packages.${pkgs.system}.default;
  cfg = config.programs.cassiopea;
in {
  options.programs.cassiopea = {
    enable = mkEnableOption "Cassiopea wayland shell";
  };

  config = mkIf cfg.enable (mkMerge [
    {
      home.packages = [package];
    }
  ]);
}
