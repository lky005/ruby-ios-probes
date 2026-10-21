#!/bin/sh
# Synthetic HFS+ loop-mount check. No Apple material; only a temp image.
set -u

if [ "$(id -u)" -ne 0 ]; then
    if command -v sudo >/dev/null 2>&1; then
        exec sudo "$0" "$@"
    fi
    echo "FAIL: run as root or install sudo"
    exit 1
fi

if ! command -v mkfs.hfsplus >/dev/null 2>&1; then
    echo "SKIP: mkfs.hfsplus not found"
    exit 0
fi

tmp=$(mktemp -d) || exit 1
img="$tmp/test.img"
mnt="$tmp/mnt"
cleanup() {
    umount "$mnt" 2>/dev/null || true
    rm -rf "$tmp"
}
trap cleanup EXIT INT TERM

truncate -s 64M "$img" || { echo "FAIL: truncate"; exit 1; }
if ! mkfs.hfsplus -J "$img" >/dev/null 2>&1; then
    echo "FAIL: mkfs.hfsplus"
    exit 1
fi
mkdir -p "$mnt"
if ! mount -o loop -t hfsplus "$img" "$mnt" 2>"$tmp/mount.err"; then
    echo "FAIL: loop mount: $(cat "$tmp/mount.err")"
    exit 1
fi
printf 'probe\n' > "$mnt/probe.txt" || { echo "FAIL: write"; exit 1; }
sync
umount "$mnt" || { echo "FAIL: umount"; exit 1; }
if ! mount -o loop,ro -t hfsplus "$img" "$mnt" 2>"$tmp/romount.err"; then
    echo "FAIL: read-only remount: $(cat "$tmp/romount.err")"
    exit 1
fi
if [ "$(cat "$mnt/probe.txt" 2>/dev/null)" = "probe" ]; then
    echo "PASS: synthetic HFS+ loop mount"
else
    echo "FAIL: probe file mismatch"
    exit 1
fi
umount "$mnt" || true
echo "PASS: cleanup"
