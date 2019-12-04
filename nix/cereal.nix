{ stdenv, fetchFromGitHub, cmake, python3, ninja, lib, moltenVkSrc }:
let
  # Update rev in lockstep according to DEPs file
  rev = (lib.strings.removeSuffix "\n"
    (builtins.readFile (moltenVkSrc + /ExternalRevisions/cereal_repo_revision)));

in stdenv.mkDerivation rec {
  name = "cereal";
  inherit rev;

  src = builtins.fetchGit {
    url = "https://github.com/USCiLab/cereal.git";
    rev = "${rev}";
  };
  buildCommand = ''
    mkdir $out
    '';

  cmakeFlagsArray = [ "-DJUST_INSTALL_CEREAL=yes" ];

  enableParallelBuilding = true;

  buildInputs = [ cmake python3 ninja ];

}
