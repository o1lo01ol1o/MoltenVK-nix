let
  nixOverride = ./nixpkgs.json;
  pinnedNixpkgsUnstable =
    let spec = builtins.fromJSON (builtins.readFile nixOverride);
    in (builtins.fetchTarball {
      url = "${spec.url}/archive/${spec.rev}.tar.gz";
      inherit (spec) sha256;
    });
  nixpkgs' = import pinnedNixpkgsUnstable { };
  moltenVkSrc = builtins.fetchGit {
    url = "https://github.com/KhronosGroup/MoltenVK.git";
    rev = "70749b0618695128abb886b4c6808bc9124786c0";
  };
in { nixpkgs ? nixpkgs', xcodeBaseDir ? "/Applications/Xcode.app"
, xcodeVersion ? "11.3.1" }:
with nixpkgs;
let

  spirv-cross = import ./nix/spirv-cross.nix {
    inherit stdenv fetchFromGitHub cmake python3 ninja lib moltenVkSrc;
  };

  cereal = import ./nix/cereal.nix {
    inherit stdenv fetchFromGitHub cmake python3 ninja lib moltenVkSrc;
  };

  vulkan-headers = import ./nix/vulkan-headers.nix {
    inherit stdenv fetchFromGitHub cmake python3 ninja lib moltenVkSrc;
  };

  vulkan-portability = import ./nix/vulkan-portability.nix {
    inherit stdenv fetchFromGitHub cmake python3 ninja lib moltenVkSrc;
  };

  vulkanSamples = import ./nix/vulkanSamples.nix {
    inherit stdenv fetchFromGitHub cmake python3 ninja lib moltenVkSrc;
  };

  spirv-headers =
    import ./nix/spirv-headers.nix { inherit stdenv fetchFromGitHub cmake; };

  spirv-tools = import ./nix/spirv-tools.nix {
    inherit stdenv fetchFromGitHub python3 cmake lib spirv-headers ninja;
  };

  glslang = import ./nix/glslang.nix {
    inherit stdenv fetchFromGitHub cmake python3 ninja lib bison jq
      spirv-headers spirv-tools moltenVkSrc;
  };

  vulkan-tools = import ./nix/vulkan-tools.nix {
    inherit stdenv fetchFromGitHub cmake python3 ninja lib glslang moltenVkSrc;
  };

  vulkan-loader = import ./nix/vulkan-loader.nix {
    inherit stdenv fetchFromGitHub cmake python3 ninja vulkan-headers;
  };

  vulkan-layers = import ./nix/vulkan-layers.nix {
    inherit stdenv fetchFromGitHub cmake python3 ninja vulkan-headers glslang
      spirv-headers spirv-tools;
  };

  xcodeenvSrc = builtins.fetchGit {
    url = "https://github.com/svanderburg/nix-xcodeenvtests.git";
    rev = "ef4ef24802fa3822100ed3e1628307b20017711e";
  };

  xcodeenv = import (xcodeenvSrc + /xcodeenv) { inherit (nixpkgs) stdenv; };
  xcodewrapper = xcodeenv.composeXcodeWrapper {
    inherit xcodeBaseDir;
    version = xcodeVersion;
  };

  moltenVKWithExternals = stdenv.mkDerivation rec {
    pname = "MoltenVkWithExternals";
    version = "70749b0618695128abb886b4c6808bc9124786c0";
    src = moltenVkSrc;

    buildCommand = ''
      mkdir $out
      mkdir $out/build
      cp -r $src/. $out
      cd $out
      mkdir External
      cp --no-preserve=mode -r "${cereal.src}" External/cereal # NB. --no-preserve=mode -r will also remove +x.
      cp --no-preserve=mode -r "${vulkan-headers.src}" External/Vulkan-Headers
      cp --no-preserve=mode -r "${vulkan-portability.src}" External/Vulkan-Portability
      cp --no-preserve=mode -r "${spirv-cross.src}" External/SPIRV-Cross
      cp --no-preserve=mode -r "${glslang.src}" External/glslang

      cp --no-preserve=mode -r "${spirv-tools.src}" External/glslang/External/spirv-tools
      ln -s "${spirv-headers.src}" External/glslang/External/spirv-tools/external/spirv-headers
      cp --no-preserve=mode -r "${spirv-tools}/." External/glslang/External/spirv-tools
      cp --no-preserve=mode -r "${vulkan-tools.src}" External/Vulkan-Tools
      cp --no-preserve=mode -r "${vulkanSamples.src}" External/VulkanSamples
      xcodebuild -quiet -project "ExternalDependencies.xcodeproj"	-scheme "ExternalDependencies" -derivedDataPath "$out/build" build
    '';

    propagatedBuildInputs = [
      spirv-cross
      cereal
      vulkan-portability
      vulkan-tools
      vulkan-headers
      glslang
      spirv-headers
      spirv-tools
    ];

    nativeBuildInputs = [ pkgconfig cmake python3 ninja xcodewrapper ];
    buildInputs = [ ];
    enableParallelBuilding = true;

  };
in stdenv.mkDerivation rec {
  pname = "MoltenVk";
  src = moltenVKWithExternals;
  version = moltenVKWithExternals.version;
  buildCommand = ''
    mkdir $out
    mkdir $out/build
    cp -r $src/. $out
    chmod -R +w $out

    cd $out
    export PATH=${xcodewrapper}/bin:$PATH
    xcodebuild -quiet -project MoltenVKPackaging.xcodeproj -scheme "MoltenVK Package" -derivedDataPath "$out/build" build
    cp --no-preserve=mode -r $out/build/Build/Products/Release $out/lib
  '';
  propagatedBuildInputs = [
    spirv-cross
    cereal
    vulkan-portability
    vulkan-tools
    vulkan-headers
    glslang
    spirv-headers
    spirv-tools
    vulkan-loader
    vulkan-layers
  ];
  # TODO: iOS condition here.
  setupHook = writeText "setup-hook" ''
    export VK_LAYER_PATH=${vulkan-layers}/share/vulkan/explicit_layer.d
    export VK_ICD_FILENAMES=@out@/Package/Release/MoltenVK/macOS/dynamic/MoltenVK_icd.json
    export DYLD_LIBRARY_PATH=@out@/Package/Release/MoltenVK/macOS/dynamic/
  '';

}

