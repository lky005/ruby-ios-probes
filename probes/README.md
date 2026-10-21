# Probes

Read-only checks. Nothing here writes to a device or stores Apple material.

- `host/check-env.sh`: disk, memory, FUSE, loop, toolchain and device tools.
- `host/check-loop.sh`: creates a small synthetic HFS+ image, loop-mounts it,
  writes one file, unmounts and verifies it read-only.
- `device/probe-twrp.sh`: TWRP version, slot, partition sizes, ICL block state
  and the SWEETLOG ring hash. It only uses `dd` reads.
