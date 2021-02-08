{ stdenv, fetchFromGitHub, cmake, python3, ninja, lib, moltenVkSrc}:
let
  # Update rev in lockstep according to DEPs file
  rev =  (lib.strings.removeSuffix "\n" (builtins.readFile (moltenVkSrc + /ExternalRevisions/VulkanSamples_repo_revision)));
in

stdenv.mkDerivation rec {
  name = "VulkanSamples";
  inherit rev;

    src = builtins.fetchGit {
        url = "https://github.com/LunarG/VulkanSamples.git";
        rev = "${rev}";
      };
  


  buildInputs = [ cmake python3 ];

}