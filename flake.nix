{
  description = "v3_fw";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=release-24.11";
  };

  outputs =
    {
      self,
      nixpkgs,
      ...
    }@inputs:
    let
      lib = (import nixpkgs { system = "x86_64-linux"; }).lib;
    in
    {
      packages = {
        "aarch64-darwin" = {
          "demo-hardcode-system" = import (self + "system-cores.nix") {
            # Example shows how you can provide the system
            # argument to import nixpkgs and satisfy the
            # derivation's system input.
            #
            # nix build .#demo-hardcode-system --arg system aarch64-darwin
            pkgs = import nixpkgs { system = "aarch64-darwin"; };
            system = "aarch64-darwin";
          };
        }
      }
    };
}
