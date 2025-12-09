{
  pkgs,
  ags,
  system,
  extraPackages,
}:
pkgs.mkShell {
  buildInputs = [
    (ags.packages.${system}.default.override {
      inherit extraPackages;
    })
  ];
}
