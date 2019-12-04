# MoltenVK-nix
nix expressions for building the MoltenVK library (and utilities) (on darwin)

Doing
```bash
$ nix-build
```

Should get you some build products based off the commit defined in `default.nix`.  Most of these depend on pinned revisions of other deps but a couple aren't.  So if you want to update to another revision, you may have to do some prodding to get get `vulkan-layers` and `vulkan-loader` to build.
