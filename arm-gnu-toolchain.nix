{
  pkgs,
  system,
  ...
}:
let
  # The release to use.
  release = "14.2-rel1";

  # Specify the target toolchain to build.
  # This allows the toolchain to specialize for different architectures.
  # Available options are specified in the ARM GNU Devtools documentation.
  # https://gitlab.arm.com/tooling/gnu-devtools-for-arm#readme
  target = "arm-none-eabi";

  # Available prebuilt toolchains from ARM.
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


  # Use the gnu-devtools repo to assist with the build.
  gnu-devtools-info = rec {
    tag = "v1.1.3";
    url = "https://git.gitlab.arm.com/tooling/gnu-devtools-for-arm/-/archive/${tag}/gnu-devtools-for-arm-${tag}.tar.gz";
    sha256 = "sha256-ktwf8ENfxY3oI0zlnRigmjAlPF3JopVP10xQn9y5rY8=";
  };

  # ####
  # Machinery below
  # ####

  selectedRelease =
    if builtins.hasAttr release releases then
      release
    else
      throw "No release available for ${release}";
  
  selectedReleaseInfo = releases.${selectedRelease};
  selectedReleaseHash = hashes.${selectedRelease};
in
pkgs.stdenv.mkDerivation rec {
  pname = "arm-embedded-toolchain";
  version = release;

  buildInputs = with pkgs; [
    # deterministic-uname
    texinfo6_5
    coreutils
  ];

  src = pkgs.fetchurl {
    url = selectedReleaseInfo.url_tar_xz;
    sha256 = selectedReleaseHash;
  };

  tools = pkgs.fetchurl {
    url = gnu-devtools-info.url;
    sha256 = gnu-devtools-info.sha256;
  };

  phases = [
    "unpackPhase"
    "buildPhase"
    "installPhase"
  ];

  unpackPhase = ''
    # extract arm gnu toolchain source
    mkdir -p $out/src
    tar -xf ${src} -C $out/src
    
    # extract gnu-devtools-for-arm
    mkdir -p $out/src/gnu-devtools-for-arm
    tar -xf ${tools} -C $out/src/gnu-devtools-for-arm --strip-components=1
  '';

  buildPhase = ''
    export PATH="$out/src/gnu-devtools-for-arm:$$PATH"
    build-gnu-toolchain.sh --target=${target} start
  '';

  installPhase = ''
    # install the full source
    # mkdir -p $out
    # cp -r * $out

    # mkdir -p $out
    # mv * $out
  '';
}
