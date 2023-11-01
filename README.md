# amd-patched-mesa
Use VAAPI w/ Vulkan of this lib until upstream mesa is patched

With this method: https://bbs.archlinux.org/viewtopic.php?id=244031&p=37 @hmann
```shell
# Download mesa-git PKGBUILD
curl "https://aur.archlinux.org/cgit/aur.git/snapshot/mesa-git.tar.gz" -o mesa-git.tar.gz
tar -xvf mesa-git.tar.gz
cd mesa-git

# Extract and patch sources
makepkg -so
cd src/mesa
curl -L "https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/23214.patch" | git am
curl -L "https://github.com/hannesmann/mesa/commit/c3a318016df57858eec2ff54828e01f9bd43744a.patch" | git am
# Optional, this is a workaround for the blocky filtering on videos
curl -L "https://github.com/hannesmann/mesa/commit/99f5bf72000de3ed49bd3f8acdac1bd162361986.patch" | git am

# Build and install package
cd ../..
makepkg -se
```

Compiled on latest Arch LLVM 16, mainly for use with flatpak bundle(icd.d files path modified)
