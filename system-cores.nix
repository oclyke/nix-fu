{
  pkgs ? import <nixpkgs> {},
  system ? builtins.currentSystem,
  ...
}:
let
  pname = "cores";
  version = "0.0.1";
  meta = with pkgs.lib; {
    description = "determine number of cores on the host system at build time";
    homepage = "https://github.com/oclyke/nix-fu";
  };

  derivations = {
    # provide a default in case the system is not supported
    "default" = pkgs.runCommand "cores-default" {} ''
      echo "1" > $out
    '';

    # linux uses nproc
    "linux" = pkgs.runCommand "cores-linux" {} ''
      echo "$(nproc)" > $out
    '';

    # osx uses sysctl
    # https://developer.apple.com/documentation/kernel/1387446-sysctlbyname/determining_system_capabilities
    "darwin" = pkgs.stdenv.mkDerivation {
      name = "cores-darwin";
      buildInputs = [
        pkgs.sysctl
      ];
      installPhase = ''
        echo "$(sysctl -n hw.ncpu)" > $out
      '';
      dontUnpack = true;
      dontPatch = true;
      dontFixup = true;
      dontConfigure = true;
      dontBuild = true;
      dontCheck = true;
      dontInstallCheck = true;
      dontDist = true;
      dontClean = true;
      src = null; # dummy src
    };
  };

  derivKeyBySystem = {
    "x86_64-linux" = "linux";
    "aarch64-linux" = "linux";
    "x86_64-darwin" = "darwin";
    "aarch64-darwin" = "darwin";
  };

  derivKey = if builtins.hasAttr system derivKeyBySystem then builtins.getAttr system derivKeyBySystem else "default";

  deriv = builtins.getAttr derivKey derivations;
in
  deriv

