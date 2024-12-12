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
    keyboard.keyboard_identifier = mkOption {
      type = types.str;
      default = "1:1:AT_Translated_Set_2_keyboard";
      example = "1:1:AT_Translated_Set_2_keyboard";
      description = ''
        Set keyboard identifier to be used by cassiopea.
      '';
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      home.packages = [package];
    }

    (mkIf (cfg.keyboard.keyboard_identifier != null && cfg.keyboard.keyboard_identifier != "") {
      home.sessionVariables = {
        KEYBOARD_IDENTIFIER = config.programs.cassiopea.keyboard.keyboard_identifier;
      };
    })
  ]);
}
