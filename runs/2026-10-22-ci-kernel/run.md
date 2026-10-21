# Run card: CI kernel test

- date (UTC): 2026-10-22
- probe: device boot of the CI-built kernel on the A' root
- device class: ruby / MT6877 (no serial recorded)
- root: A' `55e2ab2c...` (not modified by the boot image flash)

## Artifacts

- CI run: `39648068844`; commit `7418bce`; patchset `de1824c2...`
- kernel: `8a80855d1f615cf72f6ebb9f6213d0d55c8f799ad80286f0aab9f80d3215f38a`
- payload: `2749bf1cf398f750d25ed6e84bbb529d5cc5ba3e1ef6be464bff09d0ec87a053`
- boot image: `87dd4910247cf746df281e77cdf8d63528a148757a82e2b97be58ee5d9183162`
- reference 0084 restored afterwards: `94c639d1...`

## Result

Lock screen -> autoswipe -> desktop.

## Evidence

- ring: `480e5e7b72364dc815a5f1d482ca47d4d90164d9e928003efa6bb4fe329e0a86`;
  decoded text
  `760166f620cdcd2ede0763ee0ad86d46f86662ecf7e009ef0317401a79440dc5`.
- autoswipe: 3 attempts, all with `edge`.
- crashes: `driverkitd` and `PosterBoard` (known); no lsd/SpringBoard/
  backboardd.
- ICL block: `4a489542...`.

## Caveat

The payload tool came from upstream ref `33852e3`, not the pinned `5095ac1`.
The CI kernel booted; the strict pinned payload rebuild is still open.

## Notes

- The root is A'; post-boot runtime writes make the live root A''. Do not
  compare the live root to A'. See `HASHES.md`.
- No Apple images or device dumps are included; hashes only.
