# MoltenVK-nix
nix expressions for building the MoltenVK library (and utilities) (on darwin)

Doing
```bash
$ nix-build
```

Should get you some build products based off the commit defined in `default.nix`.  Most of these depend on pinned revisions of other deps but a couple aren't.  So if you want to update to another revision, you may have to do some prodding to get get `vulkan-layers` and `vulkan-loader` to build.

# Status
This is still alpha status as I work out how to get everything to get close to parity with the LunarGSDK.  If it looks like I'm going to maintain it for some period and the code cleans up some, I'll upstream to `nixpkgs`.  If you would like to upstream to `nixpkgs`, please reach out.
