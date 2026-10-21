# Run card: GitHub-hosted host check

- date (UTC): 2026-10-22
- probe: host environment + synthetic HFS+ loop mount
- runner: GitHub-hosted `ubuntu-latest` (4 vCPU, 15 GiB RAM, 86 GiB free)
- workflow: `host-check`
- result: environment OK; synthetic HFS+ loop mount FAIL

## Observed

Present: `curl`, `python3`, `git`, `clang`, `ld.lld`, `mkfs.hfsplus`,
`fsck.hfsplus`, `7z`, `losetup`, `fusermount`, `fusermount3`, `sudo`,
`/dev/fuse`, passwordless sudo.

Missing: `adb`, `fastboot`, `apfs-fuse`, `img2simg`.

Loop mount:

```text
FAIL: loop mount: mount: ... unknown filesystem type 'hfsplus'
```

## Conclusion

The GitHub-hosted runner has enough disk for a 16 GiB build, but its kernel
does not provide the HFS+ filesystem used by the current `mkiosroot` method.
It also lacks `apfs-fuse`. A cloud build would need either:

- a self-hosted runner with HFS+/FUSE support (recommended), or
- a userspace HFS+ writer instead of a kernel mount.

Device probes cannot run on GitHub-hosted runners; they need local `adb` and
a TWRP-booted device.
