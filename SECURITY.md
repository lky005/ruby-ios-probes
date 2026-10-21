# Security

- The probes are **read-only by default**. The device probe reads a 4 KiB ICL
  block and a 4 MiB SWEETLOG ring; it never writes to a block device, never
  calls `blkpatch`, and never flashes anything.
- Run device probes only on a device you own and are authorized to test.
- Do not commit serial numbers, IMEI, MAC addresses, Apple account data,
  personal paths or raw device dumps. The `runs/TEMPLATE.md` file lists the
  fields that are safe to record.
- Generated reports can contain host paths. Keep them outside the repository or
  sanitize them before committing.
- Do not paste secrets or personal data into issues or pull requests.
- For a sensitive report, use GitHub's private security advisory for this
  repository instead of a public issue.
