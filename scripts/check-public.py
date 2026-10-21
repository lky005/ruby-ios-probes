#!/usr/bin/env python3
"""Fail if the public probe tree contains binaries, Apple firmware or PII.

Scans tracked files only, so generated reports and untracked raw data are not
mistaken for repository content.
"""
import os
import re
import subprocess
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SELF = "scripts/check-public.py"

FORBIDDEN = {
    ".img", ".bin", ".elf", ".o", ".a", ".dtb", ".dtbo", ".dmg", ".ipsw",
    ".zip", ".7z", ".tar", ".gz", ".jpg", ".jpeg", ".png", ".mp4", ".mov",
    ".log",
}
TEXT = {
    ".md", ".py", ".sh", ".c", ".h", ".yml", ".yaml", ".txt", ".gitignore",
}
PII = [
    (re.compile(r"C:\\\\Users\\\\", re.I), "personal Windows path"),
    (re.compile(r"D:\\\\ios-ruby-work", re.I), "personal work path"),
    (re.compile(r"\blky" + "005\b", re.I), "personal handle"),
    (re.compile("gh" + r"p_[A-Za-z0-9]{20,}"), "GitHub token"),
    (re.compile("github_" + "pat_"), "GitHub token"),
    (re.compile(r"AKIA[0-9A-Z]{16}"), "AWS key"),
    (re.compile(r"BEGIN [A-Z ]*PRIVATE KEY"), "private key"),
    (re.compile(r"[\w.+-]+@[\w.-]+\.[A-Za-z]{2,}"), "email address"),
]

PROJECT_URLS = {
    "https://github.com/lky005/ruby-ios-bringup",
    "https://github.com/lky005/ruby-ios-probes",
}


def tracked_files():
    out = subprocess.check_output(
        ["git", "-C", ROOT, "ls-files", "-z"], text=False)
    for name in out.decode("utf-8", "replace").split("\0"):
        if name:
            yield name


def main():
    bad = []
    for rel in tracked_files():
        if rel == SELF:
            continue
        path = os.path.join(ROOT, rel)
        ext = os.path.splitext(rel)[1].lower()
        if ext in FORBIDDEN:
            bad.append(f"forbidden file: {rel}")
            continue
        if ext not in TEXT and os.path.basename(rel) != ".gitignore":
            continue
        try:
            text = open(path, encoding="utf-8", errors="ignore").read()
        except OSError:
            continue
        for url in PROJECT_URLS:
            text = text.replace(url, "")
        for rx, label in PII:
            if rx.search(text):
                bad.append(f"{label}: {rel}")
    if bad:
        print("\n".join("FAIL  " + item for item in bad))
        return 1
    print("ok    public tree: no forbidden files or PII")
    return 0


if __name__ == "__main__":
    sys.exit(main())
