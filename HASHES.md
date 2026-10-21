# Hash stability

Two kinds of hashes appear in this repository. Do not treat them the same.

## Fixed / pre-boot (identity)

Compare these before boot:

- patchset `de1824c2...`; the boot args in the main project;
- ICL blocks `ae317804...` / `4a489542...`;
- named root snapshots: A `e698339d...`, B `985c30...`, C `34c2882d...`,
  A' `55e2ab2c...`;
- named artifacts: reference 0084 `94c639d1...`; 2026-10-22 CI kernel
  `8a80855d...`, payload `2749bf1c...`, image `87dd4910...`.

These are identities for the named files/snapshots. B and C full images are not
retained; A' is one first-boot snapshot. A new first boot is a new state (A'').
Kernel CI builds are not bit-identical; the patchset hash is the reproducibility
gate; record the actual artifact hash for each run.

## Volatile / post-boot (do not require a match)

- the live root after any boot (A' -> A''), UUIDs/timestamps, logs and caches;
- the SWEETLOG ring and its decoded text;
- UI pixels, timing, and crash timing/counts.

A new first boot from the same B+NOP will not reproduce A' byte-for-byte. The
live root after a later boot is not A'. These hashes are observations, not a
contract.

## Rule

Compare pre-boot identity, then use behavior: lock screen, autoswipe, desktop,
and the ring markers (autoswipe attempts, crash set). Post-boot hashes are
recorded as evidence only.
