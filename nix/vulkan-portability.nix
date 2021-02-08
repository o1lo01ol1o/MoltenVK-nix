{ stdenv, fetchFromGitHub, cmake, python3, ninja, lib, moltenVkSrc}:
let
  # Update rev in lockstep according to DEPs file
  rev =  (lib.strings.removeSuffix "\n" (builtins.readFile (moltenVkSrc + /ExternalRevisions/Vulkan-Portability_repo_revision)));
in

stdenv.mkDerivation rec {
  name = "Vulkan-Portability";
  inherit rev;

    src = builtins.fetchGit {
      url = "https://github.com/KhronosGroup/Vulkan-Portability.git";
      rev = "${rev}";
    };
    

    buildCommand = ''
    mkdir $out
    # cp -r $src/. $out
    # cd $out
    # ls -l
    # mkdir build
    # cd build
    # cmake -G Ninja -D CMAKE_BUILD_TYPE=Release -D CMAKE_INSTALL_PREFIX=install ..
    # ninja 
    '';


  buildInputs = [ cmake python3 ninja ];

}