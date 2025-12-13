{
  pkgs,
  ags,
  system,
  extraPackages,
}: let
  pname = "cassiopea";
  entry = "app.tsx";
in
  pkgs.stdenv.mkDerivation {
    name = pname;
    src = ../.;

    nativeBuildInputs = with pkgs; [
      wrapGAppsHook3
      gobject-introspection
      makeWrapper
      ags.packages.${system}.default
    ];

    buildInputs = extraPackages ++ [pkgs.gjs];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin
      mkdir -p $out/share
      cp -r * $out/share
      ags bundle ${entry} $out/bin/${pname} -d "SRC='$out/share'"

      wrapProgram $out/bin/${pname} \
      --prefix PATH : ${pkgs.lib.makeBinPath extraPackages}

      runHook postInstall
    '';
  }
