{
  pkgs,
  system,
  ...
}:
let
  # The release to use.
  release = "14.2-rel1";

  # Available source releases from ARM.
  releases = {
    "14.2-rel1" = {
      url_tar_xz = "https://developer.arm.com/-/media/Files/downloads/gnu/14.2.rel1/srcrel/arm-gnu-toolchain-src-snapshot-14.2.rel1.tar.xz";
      url_tar_xz_asc = "https://developer.arm.com/-/media/Files/downloads/gnu/14.2.rel1/srcrel/arm-gnu-toolchain-src-snapshot-14.2.rel1.tar.xz.asc";
      url_tar_xz_sha256asc = "https://developer.arm.com/-/media/Files/downloads/gnu/14.2.rel1/srcrel/arm-gnu-toolchain-src-snapshot-14.2.rel1.tar.xz.sha256asc";
      url_manifest_txt = "https://developer.arm.com/-/media/Files/downloads/gnu/14.2.rel1/srcrel/arm-gnu-toolchain-src-snapshot-14.2.rel1-manifest.txt";
    };
  };

  # Nix store hashes for the downloaded tarballs.
  # When adding a new release, you will need to add the
  # hash for the tarball here.
  # (add a blank string "" as the value initially, Nix will
  # yell at you again with the computed hash)
  hashes = {
    "14.2-rel1" = "sha256-5kBfIPioF6UNktv3l00O53cI39+eeZAKWcXTQ7Rk75w=";
  };

  # ####
  # Machinery below
  # ####

  selectedRelease =
    if builtins.hasAttr release releases then
      release
    else
      throw "No release available for ${release}";
in
pkgs.stdenv.mkDerivation rec {
  pname = "arm-gnu-toolchain-source";
  version = release;

  meta = with pkgs.lib; {
    description = "arm-gnu-toolchain";
    homepage = "https://developer.arm.com/downloads/-/arm-gnu-toolchain-downloads#";
  };

  src = pkgs.fetchurl {
    url = releases.${selectedRelease}.url_tar_xz;
    sha256 = hashes.${selectedRelease};
  };

  phases = [
    "unpackPhase"
  ];

  unpackPhase = ''
    mkdir -p $out
    tar -xf $src -C $out
  '';
}
