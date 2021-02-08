{ stdenv, fetchFromGitHub, cmake, python3, ninja, lib, moltenVkSrc}:
let
  # Update rev in lockstep according to DEPs file
  rev =  (lib.strings.removeSuffix "\n" (builtins.readFile (moltenVkSrc + /ExternalRevisions/Vulkan-Headers_repo_revision)));
in



stdenv.mkDerivation rec {
  name = "vulkan-headers";
  inherit rev;

    src = builtins.fetchGit {
      url = "https://github.com/KhronosGroup/Vulkan-Headers.git";
      rev = "${rev}";
    };


  nativeBuildInputs = [ cmake ];
  meta = with lib; {
    description = "Vulkan Header files and API registry";
    homepage    = "https://www.lunarg.com";
    license     = licenses.asl20;
  };

}