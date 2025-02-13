# nix-fu

Expressions of Nix mastery.

# channels

Channels are snapshots of the Nixpkgs repository.
Nearly all Nix operations eventually tie back to some channel.
Usually the host system is configured to use a given channel,
but this can be overriden.

For example one might want to use a particular version of libclang which was included in the 23.05 channel.
A temporary solution would be to use the `nix-shell` command with the `--channel` option.
```
nix-shell -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/refs/tags/23.05.tar.gz -p libclang
```

You can find the complete listing of channel archives in the [nixpkgs repository tags](https://github.com/NixOS/nixpkgs/tags).
Another official listing of channels is at the [NixOS channels page](https://channels.nixos.org/).

Now, you might have noticed that there is no explicit mention of which version of libclang is going to be used.
That's certainly a drawback of using this approach – there is not a nixpkgs channel for every release of every package in the nixpkgs repository.
(that would be insane!)

One can use the channels to quickly try a couple different versions of a package but the way to get particular versions is to write and evaluate a derivation.

# index

* `system-cores.nix`: derivation whose output is the number of cores available on the system. speicalizes the derivation for the current system.
* `clang.nix`: derivation for building clang from source.
* `arm-gnu-toolchain-arm-none-eabi-prebuilt.nix`: provides a prebuilt version of the ARM GNU Toolchain in the arm-none-eabi flavor.
* `arm-gnu-toolchain-source.nix`: exposes the ARM GNU Toolchain source code as a derivation.

# nix store

The nix store is a directory where all the outputs of nix derivations are stored.
Over time the store can grow quite large.
Run the garbage collector in order to reclaim space.

`nix-store --gc --print-dead` shows the paths of all the dead outputs in the store.
`nix-collect-garbage -d` employs the garbage collector to remove all the dead outputs.
