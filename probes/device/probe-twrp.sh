#!/bin/sh
# Read-only TWRP probe for ruby/MT6877. Never writes to a block device.
set -u
export MSYS_NO_PATHCONV=1
export MSYS2_ARG_CONV_EXCL='*'

say() { printf '%s\n' "$*"; }
have() { command -v "$1" >/dev/null 2>&1; }
hash_file() {
    if have sha256sum; then
        sha256sum "$1" | awk '{print $1}'
    elif have shasum; then
        shasum -a 256 "$1" | awk '{print $1}'
    else
        echo unknown
    fi
}

have adb || { echo "FAIL: adb not found"; exit 2; }
state=$(adb get-state 2>/dev/null | tr -d '\r')
[ "$state" = "device" ] || { echo "FAIL: no adb device ($state)"; exit 2; }

twrp=$(adb shell getprop ro.twrp.version 2>/dev/null | tr -d '\r')
[ -n "$twrp" ] || { echo "FAIL: ro.twrp.version empty; not in TWRP"; exit 2; }

say "# twrp-probe $(date -u '+%Y-%m-%dT%H:%M:%SZ')"
say "twrp: $twrp"
say "slot: $(adb shell getprop ro.boot.slot_suffix 2>/dev/null | tr -d '\r')"

say "## block devices"
adb shell 'ls -l /dev/block/by-name' 2>/dev/null | tr -d '\r' | head -40 || true

say "## sizes"
for p in boot_a iosroot userdata; do
    b=$(adb shell "blockdev --getsize64 /dev/block/by-name/$p" 2>/dev/null | tr -d '\r')
    say "$p: ${b:-unknown} bytes"
done

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT INT TERM

say "## ICL block 2438140"
adb exec-out 'dd if=/dev/block/by-name/iosroot bs=4096 skip=2438140 count=1 2>/dev/null' > "$tmp/icl.bin"
if [ -s "$tmp/icl.bin" ]; then
    h=$(hash_file "$tmp/icl.bin")
    say "sha256: $h"
    case "$h" in
        ae3178046fe7cb9e08291c39dc4773429be26c35472c6fbd9135d5f2a225fd73)
            say "state: original (no NOP)" ;;
        4a4895422dcec766b90b65c067ecb06ef8fd3e346c03ee7e2464a85f62a73b74)
            say "state: ICL NOP applied" ;;
        *)
            say "state: unknown (do not assume)" ;;
    esac
else
    say "FAIL: could not read block"
fi

say "## SWEETLOG ring"
bytes=$(adb shell 'blockdev --getsize64 /dev/block/by-name/iosroot' 2>/dev/null | tr -d '\r')
case "$bytes" in
    ''|*[!0-9]*)
        say "SKIP: iosroot size unknown" ;;
    *)
        if [ "$bytes" -gt 4198400 ]; then
            skip=$((bytes / 4096 - 1025))
            adb exec-out "dd if=/dev/block/by-name/iosroot bs=4096 skip=$skip count=1025 2>/dev/null" > "$tmp/ring.bin"
            if [ -s "$tmp/ring.bin" ]; then
                say "bytes: $(wc -c < "$tmp/ring.bin")"
                say "sha256: $(hash_file "$tmp/ring.bin")"
                magic=$(dd if="$tmp/ring.bin" bs=1 count=8 2>/dev/null | tr -d '\0')
                say "magic: ${magic:-none}"
            else
                say "FAIL: could not read ring"
            fi
        else
            say "SKIP: iosroot too small for a 4 MiB ring"
        fi
        ;;
esac

say "done (read-only)"
