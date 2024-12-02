{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    astal = {
      url = "github:aylur/astal";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    astal,
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    packages.${system}.default = astal.lib.mkLuaPackage {
      inherit pkgs;
      name = "cassiopea"; # how to name the executable
      src = ./.; # should contain init.lua

      # add extra glib packages or binaries
      extraPackages = [
        astal.packages.${system}.battery
        astal.packages.${system}.mpris
        astal.packages.${system}.wireplumber
        astal.packages.${system}.network
        astal.packages.${system}.tray
        astal.packages.${system}.io
        astal.packages.${system}.apps
        pkgs.dart-sass
      ];
    };
  };
}
