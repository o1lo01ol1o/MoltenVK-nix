{ stdenv, fetchFromGitHub, cmake, python3, ninja, lib, glslang, moltenVkSrc}:
let
  # Update rev in lockstep according to DEPs file
  rev =  (lib.strings.removeSuffix "\n" (builtins.readFile (moltenVkSrc + /ExternalRevisions/Vulkan-Tools_repo_revision)));
in

stdenv.mkDerivation rec {
  name = "Vulkan-Tools";
  inherit rev;

    src = builtins.fetchGit {
      url = "https://github.com/KhronosGroup/Vulkan-Tools.git";
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


  buildInputs = [ cmake python3 ninja glslang];

}