#!/usr/bin/env python3
"""
Patch: crop_buffer.py border expansion

Increases the crop border so that the blend_mask dilation+falloff zone
(~60px at 1080p) is fully contained within the crop area.

Original values:
  BORDER_RATIO = 0.06   →  0.10
  MIN_BORDER   = 20     →  40

This prevents the blend_mask from being clipped at the crop boundary,
which is the root cause of the visible rectangular edge artifact.
"""
import pathlib
import sys

TARGET = "crop_buffer.py"

PATCHES = [
    {
        "search":  "BORDER_RATIO = 0.06",
        "replace": "BORDER_RATIO = 0.10",
        "marker":  "0.10",
    },
    {
        "search":  "MIN_BORDER = 20",
        "replace": "MIN_BORDER = 40",
        "marker":  "MIN_BORDER = 40",
    },
]


def patch(root: pathlib.Path) -> bool:
    candidates = list(root.rglob(TARGET))
    if not candidates:
        print(f"[patch] {TARGET} not found under {root}", file=sys.stderr)
        return False
    for path in candidates:
        text = path.read_text(encoding="utf-8")
        patched = False
        for p in PATCHES:
            if p["marker"] in text:
                print(f"[patch] already patched ({p['marker']}): {path}")
                patched = True
                continue
            if p["search"] not in text:
                print(f"[patch] search string '{p['search']}' not found in {path}", file=sys.stderr)
                continue
            text = text.replace(p["search"], p["replace"], 1)
            patched = True
            print(f"[patch] applied: {p['search']} → {p['replace']} in {path}")
        if patched:
            path.write_text(text, encoding="utf-8")
            return True
    print(f"[patch] no changes applied to any {TARGET}", file=sys.stderr)
    return False


if __name__ == "__main__":
    root = pathlib.Path(sys.argv[1]) if len(sys.argv) > 1 else pathlib.Path(".")
    sys.exit(0 if patch(root) else 1)
