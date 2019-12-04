{ stdenv, fetchFromGitHub, cmake, python3, lib, spirv-headers, ninja }:

stdenv.mkDerivation rec {
  name = "SPIRV-Tools";
  # TODO: the revision is checked in glslang against the pinned .json
  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Tools";
    rev = "02910ffdffaa2966f613ede0c516645f5555c13c";
    sha256 = "132fmxh5z8l1p083jpzkrdb660dshwskhv0pqwj4a81v7z5bihj7";
  };

  buildCommand = ''
    mkdir $out
    cp -r $src/. $out
    chmod -R +w $out
    cd $out
    ln -s "${spirv-headers.src}" external/spirv-headers
    mkdir build
    cd build
    cmake -G Ninja -D CMAKE_BUILD_TYPE=Release -D CMAKE_INSTALL_PREFIX=install ..
    ninja 
  '';

  enableParallelBuilding = true;

  buildInputs = [ python3 cmake ninja ];

  cmakeFlags = [ "-DSPIRV-Headers_SOURCE_DIR=${spirv-headers.src}" ];

}
