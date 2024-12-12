{
  astal,
  pkgs,
  system,
  self,
  nix-gitignore,
}:
astal.lib.mkLuaPackage {
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

  extraLuaPackages = ps:
    with ps; [
      luaPackages.cjson
    ];

  extraPackages =
    [
      pkgs.dart-sass
      pkgs.lsof
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
}
