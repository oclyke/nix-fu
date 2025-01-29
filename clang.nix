{
  pkgs,
  system,
  ...
}:
let
  version = "19.1.7";
  sha256 = "sha256-WavqHCLmSTP61N4WcaYc25NAmHk8ejGzM/9Y3EG/82w=";
  cores = import ./cores.nix {
    inherit pkgs;
    inherit system;
  };
in
pkgs.stdenv.mkDerivation rec {
  pname = "clang";
  inherit version;

  meta = with pkgs.lib; {
    description = "clang";
    homepage = "https://clang.llvm.org/";
  };

  src = pkgs.fetchurl {
    url = "https://github.com/llvm/llvm-project/archive/refs/tags/llvmorg-${version}.tar.gz";
    inherit sha256;
  };

  buildInputs = with pkgs; [
    python3
    cmake
  ];

  # use phases
  # - unpackPhase: default
  # - configurePhase: custom
  # - buildPhase: custom
  # - installPhase: custom

  # skip phases
  dontPatch = true;
  dontFixup = true;
  dontCheck = true;
  contFixup = true;
  dontInstallCheck = true;
  dontDist = true;
  dontClean = true;

  configurePhase = ''
    mkdir build
    cd build
    cmake -DLLVM_ENABLE_PROJECTS=clang -DCMAKE_BUILD_TYPE=Release -G "Unix Makefiles" ../llvm
  '';

  buildPhase = ''
    make -j$(cat ${cores})
  '';

  installPhase = ''
    mkdir -p $out
    cp -r bin $out/bin
    cp -r lib $out/lib
    cp -r include $out/include
  '';
}

