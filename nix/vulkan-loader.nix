{ stdenv, fetchFromGitHub, cmake, python3, ninja, vulkan-headers}:


stdenv.mkDerivation rec {
  name = "Vulkan-Loader";

    src = builtins.fetchGit {
      url = "https://github.com/KhronosGroup/Vulkan-Loader.git";
      rev = "4adad4ff705fa76f9edb2d37cb57e593decb60ed"; # based on Vulkan_tools/scripts/known_good.json
    };


  cmakeFlags = ''
    -DVULKAN_HEADERS_INSTALL_DIR=${vulkan-headers}
    '';

  enableParallelBuilding = true;

  buildInputs = [ cmake python3 ninja vulkan-headers ];

}