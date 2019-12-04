{ stdenv, fetchFromGitHub, cmake, python3, ninja, lib, moltenVkSrc}:
let
  # Update rev in lockstep according to DEPs file
  rev =  (lib.strings.removeSuffix "\n" (builtins.readFile (moltenVkSrc + /ExternalRevisions/Vulkan-Headers_repo_revision)));
in



stdenv.mkDerivation rec {
  name = "Vulkan-Headers";
  inherit rev;

    src = builtins.fetchGit {
      url = "https://github.com/KhronosGroup/Vulkan-Headers.git";
      rev = "${rev}";
    };

  enableParallelBuilding = true;

  buildInputs = [ cmake python3 ninja ];

}