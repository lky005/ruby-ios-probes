#!/bin/sh
# Read-only host environment report. No Apple material, no device access.
set -u

say() { printf '%s\n' "$*"; }
have() { command -v "$1" >/dev/null 2>&1; }

say "# host-check $(date -u '+%Y-%m-%dT%H:%M:%SZ')"
say "## system"
uname -a 2>/dev/null || true
say "nproc: $(nproc 2>/dev/null || echo unknown)"

say "## memory"
free -h 2>/dev/null || true

say "## disk"
df -h . /tmp 2>/dev/null || df -h . 2>/dev/null || true

say "## tools"
for t in curl python3 git adb fastboot clang ld.lld apfs-fuse \
         mkfs.hfsplus fsck.hfsplus img2simg 7z losetup fusermount \
         fusermount3 sudo; do
    if have "$t"; then
        say "ok      $t: $(command -v "$t")"
    else
        say "missing $t"
    fi
done

say "## fuse and loop"
if [ -e /dev/fuse ]; then
    say "ok      /dev/fuse"
else
    say "missing /dev/fuse"
fi
if have losetup; then
    say "loop devices: $(losetup -a 2>/dev/null | wc -l)"
fi
if have sudo; then
    if sudo -n true 2>/dev/null; then
        say "ok      passwordless sudo"
    else
        say "warn    sudo requires a password"
    fi
fi

say "## curl"
curl --version 2>/dev/null | head -1 || true
say "done (read-only)"
