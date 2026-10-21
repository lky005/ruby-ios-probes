# Run card: B+NOP first boot -> A'

- date (UTC): 2026-10-22
- probe: device first boot (read-only evidence after the run)
- device class: ruby / MT6877 (no serial recorded)
- TWRP: 3.7.0_12-0
- target state: B+NOP (pre-boot22 pulled+seeded root + ICL NOP)
- reference kernel: 0084 image `94c639d1...`

## Result

Lock screen -> autoswipe -> desktop. Observed by the operator: 22 s to lock
screen and 30 s to autoswipe (observation; not fixed timing).

## Evidence

- A' SHA-256: `55e2ab2c6e5494f473ece06a1c2bed728ed528bb257b67f01413d1aa51c76f11`
- A' vs A: 67,765 4 KiB blocks; live diff
  `a6e11a251b777122b2b5ddabf15c3a437cd7179328e5656d46cd46a041572408`;
  index `073f5fabe743d8ba43c59439d314de8c9bcf14aca720555a231eba8ffa9d7711`.
- ring: `5a131ad9f93ce9137e4cd5cedaa117b6e05b66fea61e1ac94bde6b828bf6c16f`;
  decoded text
  `e916a9010cb079ab61bc3ed2190707c0aadce377d8a7a71ae338b615b06cfde3`.
- autoswipe: 3 attempts (variant 0/1/2), all with `edge`; driverkitd crash only;
  no lsd/SpringBoard/backboardd/PosterBoard crash.
- ICL block: `4a489542...` after the run.

## Notes

- A `e698339d...` was preserved; A' is a first-boot snapshot. A new first boot
  is a new state; post-boot hashes are volatile (see `HASHES.md`).
- The first boot used the reference 0084 image; the CI kernel test is a
  separate run card.
- No Apple images or device dumps are included; hashes only.
