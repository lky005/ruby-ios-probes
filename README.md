# ruby-ios-probes

Read-only probes for the `ruby` / MT6877 XNU + iOS bring-up.

This repository is deliberately small and contains **no Apple firmware,
IPSW/DMG files, iOS root images, dyld caches, device dumps, serials or personal
paths**. It only contains probe scripts, workflow definitions and sanitized
run cards.

## What it checks

| Probe | What it answers |
|---|---|
| `probes/host/check-env.sh` | disk, RAM, FUSE, loop, apfs-fuse, hfsprogs, python, adb/fastboot, clang/lld |
| `probes/host/check-loop.sh` | can this host create and loop-mount a small HFS+ image? (synthetic, no Apple material) |
| `probes/device/probe-twrp.sh` | TWRP version, slot, partition sizes, ICL block state, SWEETLOG ring (read-only) |
| `.github/workflows/host-check.yml` | runs the host probes on a GitHub-hosted Ubuntu runner and uploads a text report |

## Records

- [Hash stability](HASHES.md): fixed pre-boot vs volatile post-boot hashes.
- [B+NOP first boot -> A'](runs/2026-10-22-first-boot/run.md)
- [CI kernel test](runs/2026-10-22-ci-kernel/run.md)

## Quick start

Host:

```sh
sh probes/host/check-env.sh
sudo sh probes/host/check-loop.sh
```

Device (TWRP, read-only):

```sh
sh probes/device/probe-twrp.sh
```

CI: Actions -> host-check -> Run workflow. The report is a text artifact.

## Boundaries

- Read-only by default. The device probe never writes to a block device and
  never flashes anything.
- No Apple material is stored here. Users supply their own IPSW/DMG and comply
  with Apple's terms.
- Do not commit generated reports containing personal paths, serials or
  device identifiers. See `runs/TEMPLATE.md`.
- TWRP is a third-party prerequisite and is not included.

## Related project

[ruby-ios-bringup](https://github.com/lky005/ruby-ios-bringup) holds the build
recipe, success-bundle hashes and the reproduction documentation. This
repository only holds probes and run cards.

## License

MIT for the probe code. Apple material and third-party tools keep their own
terms. See `LICENSE`, `LEGAL.md` and `SECURITY.md`.
