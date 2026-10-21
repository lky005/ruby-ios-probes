# Run card: root state audit

- date (UTC): 2026-10-22
- probe: local root image state audit (read-only)
- device class: ruby / MT6877 (no serial recorded)
- artifact: external 16 GiB iOS root image; not included in this repository

## Hashes

- current image SHA-256: `e698339d0e228609c2d98f16ae8dd44a5149f2ccc19a44b98d5d08845c53f96f`
- boot22 diff set: 62,490 blocks
- pre-boot22 reconstruction SHA-256: `985c30fcca28cb79e6ad6d30a1ff4b4b6b7306b69d6e480cd7cccf4fb5ca11e3`
- ICL block 2438140: `4a4895422dcec766b90b65c067ecb06ef8fd3e346c03ee7e2464a85f62a73b74`

## Result

- The current image matches the post-boot22 blocks for all 62,490/62,490 blocks.
- A CRC scan of the whole 16 GiB against the pre-boot22 baseline found exactly
  the same 62,490 blocks: 0 extra, 0 missing.
- Replacing those 62,490 blocks with the recorded pre-boot22 blocks yields
  `985c30...`.
- Conclusion:
  - `e698339d...` = A: post-boot22 success snapshot (ICL NOP applied).
  - `985c30...` = B: pre-boot22 pulled+seeded root (ICL original).
  - The public success-bundle pin that names `985c30...` describes B, not A.
- The ICL block is `4a489542...` (NOP) in the local image; the boot22 diff
  includes the 4-byte NOP and the first-boot writes.

## Boundaries

- No Apple material is included or uploaded by this repository.
- The live device root has later boot writes and was not compared as a whole.
- Hashes only; no personal paths, serials or device dumps.
