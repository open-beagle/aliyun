#!/usr/bin/env python3
"""
Patch: blend_buffer.py edge feathering
Fixes visible square artifacts caused by blend_mask hard-clipping at the
enlarged_bbox boundary.

The blend mask dilation+falloff (~60px at 1080p) can exceed the border
added by expand_bbox (~20px), so the mask is abruptly cut at the crop edge.
This patch adds a linear feather ramp at all four edges so the blend weight
smoothly reaches zero at the crop boundary.
"""
import pathlib
import sys

TARGET = "blend_buffer.py"
SEARCH = "        blend_mask = self.blend_mask_fn(crop_mask, frame_h)"
REPLACE = """        blend_mask = self.blend_mask_fn(crop_mask, frame_h)

        # Edge feathering: prevent hard blend cutoff at crop boundary
        _feather_px = max(8, round(frame_h * 0.06))
        _bh, _bw = blend_mask.shape
        if _bh > 2 * _feather_px and _bw > 2 * _feather_px:
            _ramp = torch.linspace(0, 1, _feather_px, device=device, dtype=blend_mask.dtype)
            blend_mask[:_feather_px, :] *= _ramp[:, None]
            blend_mask[-_feather_px:, :] *= _ramp.flip(0)[:, None]
            blend_mask[:, :_feather_px] *= _ramp[None, :]
            blend_mask[:, -_feather_px:] *= _ramp.flip(0)[None, :]"""


def patch(root: pathlib.Path) -> bool:
    candidates = list(root.rglob(TARGET))
    if not candidates:
        print(f"[patch] {TARGET} not found under {root}", file=sys.stderr)
        return False
    for path in candidates:
        text = path.read_text(encoding="utf-8")
        if SEARCH not in text:
            print(f"[patch] search string not found in {path}", file=sys.stderr)
            continue
        if "_feather_px" in text:
            print(f"[patch] already patched: {path}")
            return True
        text = text.replace(SEARCH, REPLACE, 1)
        path.write_text(text, encoding="utf-8")
        print(f"[patch] patched: {path}")
        return True
    print(f"[patch] search string not found in any {TARGET}", file=sys.stderr)
    return False


if __name__ == "__main__":
    root = pathlib.Path(sys.argv[1]) if len(sys.argv) > 1 else pathlib.Path(".")
    sys.exit(0 if patch(root) else 1)
