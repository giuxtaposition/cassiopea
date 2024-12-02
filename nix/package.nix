{
  astal,
  pkgs,
  lib,
  system,
  self,
  luaPackages,
  stdenvNoCC,
  makeWrapper,
  nix-gitignore,
}: let
  cassiopea = astal.lib.mkLuaPackage {
    name = "cassiopea";
    inherit pkgs;

    src =
      nix-gitignore.gitignoreSourcePure [
        "nix/"
        "README.md"
        "*.nix"
        "*.lock"
      ]
      ../.;

    extraPackages =
      [
        pkgs.dart-sass
      ]
      ++ (with astal.packages.${system}; [
        battery
        mpris
        wireplumber
        network
        tray
        io
        apps
      ]);
  };
in
  stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "cassiopea";

    version = "1.0.0";

    src = cassiopea;

    sourceRoot = "${finalAttrs.src.name}";

    nativeBuildInputs = [
      makeWrapper
    ];

    installPhase = ''
      mkdir -p $out
      cp -r . $out/
    '';

    meta = {
      description = "My personal wayland shell";
      mainProgram = "cassiopea";
    };
  })
