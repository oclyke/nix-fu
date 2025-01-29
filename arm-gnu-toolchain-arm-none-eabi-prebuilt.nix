{
  pkgs,
  system,
  ...
}:
let
  release = "14.2.rel1";
  sha256 = "sha256-x8eP+rm+v86R2Z08JNpr9LgcAeFs9VHrL/nyW54KOBg=";
in
pkgs.stdenv.mkDerivation rec {
  pname = "arm-gnu-toolchain-prebuilt";
  version = release;

  meta = with pkgs.lib; {
    description = "arm-gnu-toolchain";
    homepage = "https://developer.arm.com/downloads/-/arm-gnu-toolchain-downloads#";
  };

  src = pkgs.fetchurl {
    url = "https://developer.arm.com/-/media/Files/downloads/gnu/${release}/binrel/arm-gnu-toolchain-${release}-darwin-arm64-arm-none-eabi.tar.xz";
    inherit sha256;
  };

  # use phases
  # - unpackPhase: default
  # - installPhase: custom

  # skip phases
  dontPatch = true;
  dontFixup = true;
  dontConfigure = true;
  dontBuild = true;
  dontCheck = true;
  contFixup = true;
  dontInstallCheck = true;
  dontDist = true;
  dontClean = true;

  installPhase = ''
    mkdir -p $out
    cp -r bin $out/bin
  '';
}

