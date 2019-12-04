{ stdenv, fetchFromGitHub, cmake}:
stdenv.mkDerivation rec {
  name = "SPIRV-Headers";
    #TODO: this really should follow the "Lockstep" DEPS of glslang
    src = fetchFromGitHub {
        owner = "KhronosGroup";
        repo = "SPIRV-Headers";
        rev = "af64a9e826bf5bb5fcd2434dd71be1e41e922563";
        sha256 = "0187ajq6902590nzyzzg9i4vcqvnd699zk3gk1x7dffkmfdjvnr6";
    };
    

  enableParallelBuilding = true;

  buildInputs = [ cmake ];

}