{ stdenv, fetchFromGitHub, cmake, python3, ninja, lib, bison, jq, spirv-headers
, spirv-tools, moltenVkSrc }:
let
  # Update rev in lockstep according to DEPs file
  rev = (lib.strings.removeSuffix "\n"
    (builtins.readFile (moltenVkSrc + /ExternalRevisions/glslang_repo_revision)));

in stdenv.mkDerivation rec {
  name = "glslang";
  inherit rev;

  src = builtins.fetchGit {
    url = "https://github.com/KhronosGroup/glslang.git";
    rev = "${rev}";
  };

  # These get set at all-packages, keep onto them for child drvs
  passthru = { inherit spirv-tools spirv-headers; };

  nativeBuildInputs = [ cmake python3 bison jq ];
  enableParallelBuilding = true;

  postPatch = ''
    cp --no-preserve=mode -r "${spirv-tools.src}" External/spirv-tools
    ln -s "${spirv-headers.src}" External/spirv-tools/external/spirv-headers
  '';

  # Ensure spirv-headers and spirv-tools match exactly to what is expected
  preConfigure = ''
    HEADERS_COMMIT=$(jq -r < known_good.json '.commits|map(select(.name=="spirv-tools/external/spirv-headers"))[0].commit')
    TOOLS_COMMIT=$(jq -r < known_good.json '.commits|map(select(.name=="spirv-tools"))[0].commit')
    if [ "$HEADERS_COMMIT" != "${spirv-headers.src.rev}" ] || [ "$TOOLS_COMMIT" != "${spirv-tools.src.rev}" ]; then
      echo "ERROR: spirv-tools commits do not match expected versions: expected tools at $TOOLS_COMMIT, headers at $HEADERS_COMMIT";
      exit 1;
    fi
  '';

  buildInputs = [ cmake python3 ninja ];

}
