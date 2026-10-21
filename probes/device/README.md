# Device probe (TWRP, read-only)

## Preconditions

- An unlocked `ruby` (Redmi Note 12 Pro 5G / MT6877) you own.
- TWRP for Android 12 flashed to `boot_a` (third-party; not included here).
- A known-good full boot image for rollback.
- `adb` working in TWRP.

## Run

```sh
sh probes/device/probe-twrp.sh
```

The script reads:

- `ro.twrp.version` and `ro.boot.slot_suffix`;
- the block-device names and sizes of `boot_a`, `iosroot`, `userdata`;
- iosroot block `2438140` (4 KiB) and its SHA-256;
- the last 4 MiB SWEETLOG ring and its SHA-256.

It never writes to a block device, never calls `blkpatch`, and never flashes.

## ICL block states

The 4 KiB block is specific to the 16.7.16 (20H392) shared cache:

- `ae317804...` = original call site;
- `4a489542...` = ICL NOP applied.

Any other value means the image is not one of the known states; do not assume.

## Sanitizing output

Save the report outside this repository or remove host paths, serial numbers,
IMEI and MAC addresses before committing. See `runs/TEMPLATE.md`.
