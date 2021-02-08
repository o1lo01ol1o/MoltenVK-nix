{ stdenv, fetchFromGitHub, cmake, python3, ninja, lib, moltenVkSrc}:
let
  # Update rev in lockstep according to DEPs file
  rev =  (lib.strings.removeSuffix "\n" (builtins.readFile (moltenVkSrc + /ExternalRevisions/SPIRV-Cross_repo_revision)));
in

stdenv.mkDerivation rec {
  name = "SPIRV-Cross";
  inherit rev;
  
    src = builtins.fetchGit {
    url = "https://github.com/KhronosGroup/SPIRV-Cross.git";
    rev = "${rev}";
  };




  buildInputs = [ cmake python3 ninja ];

}