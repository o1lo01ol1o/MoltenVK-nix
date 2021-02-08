{ stdenv, fetchFromGitHub, cmake, python3, ninja, vulkan-headers, glslang, spirv-headers, spirv-tools}:


stdenv.mkDerivation rec {
  name = "Vulkan-Layers";

    src = builtins.fetchGit {
      url = "https://github.com/KhronosGroup/Vulkan-ValidationLayers.git";
      rev = "5db6e0af00441eec792a2f87ca8626a29d17b8b4"; # set to sdk-1.1.126
      ref = "sdk-1.1.126";
    };

  # buildCommand = ''
  #   mkdir $out
  #   cp -r $src/. $out
  #   cd $out
  #   ls -l
  #   mkdir build
  #   cd build
  #   cmake -G Ninja -D CMAKE_BUILD_TYPE=Release -D CMAKE_INSTALL_PREFIX=install ..
  #   ninja 
  #   '';

  cmakeFlags = ''
    -DVULKAN_HEADERS_INSTALL_DIR=${vulkan-headers} 
    -DGLSLANG_INSTALL_DIR=${glslang}
    '';

  buildInputs = [ cmake python3 ninja glslang vulkan-headers spirv-headers spirv-tools];

}