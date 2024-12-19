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
      luaPackages.dkjson
    ];

  extraPackages =
    [
      pkgs.dart-sass
      pkgs.lsof
      pkgs.wl-gammarelay-rs
    ]
    ++ (with astal.packages.${system}; [
      battery
      mpris
      wireplumber
      network
      tray
      io
      apps
      bluetooth
      notifd
    ]);
}
