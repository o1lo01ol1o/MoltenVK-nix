{ stdenv, fetchFromGitHub, cmake, python3, pkg-config, ninja, vulkan-headers}:


stdenv.mkDerivation rec {
  name = "Vulkan-Loader";

    src = builtins.fetchGit {
      url = "https://github.com/KhronosGroup/Vulkan-Loader.git";
      rev = "4adad4ff705fa76f9edb2d37cb57e593decb60ed"; # based on Vulkan_tools/scripts/known_good.json
    };


  nativeBuildInputs = [ pkg-config cmake ];
  buildInputs = [ python3 ];

  cmakeFlags = [
    "-DVULKAN_HEADERS_INSTALL_DIR=${vulkan-headers}"
    "-DCMAKE_INSTALL_INCLUDEDIR=${vulkan-headers}/include"
  ];

  outputs = [ "out" "dev" ];

  # doInstallCheck = true;

  # installCheckPhase = ''
  #   grep -q "${vulkan-headers}/include" $dev/lib/pkgconfig/vulkan.pc || {
  #     echo vulkan-headers include directory not found in pkg-config file
  #     exit 1
  #   }
  # '';

  

}