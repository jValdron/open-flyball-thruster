#!/usr/bin/env python3
"""Compare two directories of STLs by geometry (bounding box + volume).

Usage: compare_stls.py EXPECTED_DIR ACTUAL_DIR

Different OpenSCAD builds triangulate and order facets differently, so the
files are not compared byte-for-byte. A part counts as changed if its bounding
box moves by more than BBOX_TOL mm or its volume changes by more than VOL_TOL
(relative). Exits 1 if any part changed or is missing.
"""
import struct
import sys
from pathlib import Path

BBOX_TOL = 0.01   # mm
VOL_TOL = 0.001   # 0.1 %


def triangles(path):
    data = path.read_bytes()
    if data[:5] == b"solid" and b"facet" in data[:512]:
        verts = []
        for line in data.decode(errors="ignore").splitlines():
            parts = line.split()
            if parts and parts[0] == "vertex":
                verts.append(tuple(map(float, parts[1:4])))
        return [verts[i:i + 3] for i in range(0, len(verts), 3)]
    count = struct.unpack("<I", data[80:84])[0]
    tris = []
    for i in range(count):
        f = struct.unpack("<12f", data[84 + 50 * i:84 + 50 * i + 48])
        tris.append([f[3:6], f[6:9], f[9:12]])
    return tris


def measure(path):
    tris = triangles(path)
    pts = [v for t in tris for v in t]
    lo = [min(p[i] for p in pts) for i in range(3)]
    hi = [max(p[i] for p in pts) for i in range(3)]
    vol = 0.0
    for a, b, c in tris:
        vol += (a[0] * (b[1] * c[2] - b[2] * c[1])
                - a[1] * (b[0] * c[2] - b[2] * c[0])
                + a[2] * (b[0] * c[1] - b[1] * c[0])) / 6
    return lo, hi, abs(vol)


def main(expected_dir, actual_dir):
    expected_dir, actual_dir = Path(expected_dir), Path(actual_dir)
    failed = False
    for exp in sorted(expected_dir.glob("*.stl")):
        act = actual_dir / exp.name
        if not act.exists():
            print(f"{exp.name}: MISSING from {actual_dir}")
            failed = True
            continue
        (elo, ehi, evol), (alo, ahi, avol) = measure(exp), measure(act)
        bbox_delta = max(abs(x - y) for x, y in zip(elo + ehi, alo + ahi))
        vol_delta = abs(evol - avol) / evol if evol else abs(avol)
        if bbox_delta > BBOX_TOL or vol_delta > VOL_TOL:
            print(f"{exp.name}: CHANGED (bbox delta {bbox_delta:.3f} mm, "
                  f"volume {evol / 1000:.2f} -> {avol / 1000:.2f} cm³)")
            failed = True
        else:
            print(f"{exp.name}: ok")
    for act in sorted(actual_dir.glob("*.stl")):
        if not (expected_dir / act.name).exists():
            print(f"{act.name}: NEW (not in {expected_dir})")
            failed = True
    if failed:
        print("\nCommitted STLs are out of date: run `make` and commit models/.")
    return 1 if failed else 0


if __name__ == "__main__":
    if len(sys.argv) != 3:
        sys.exit(__doc__)
    sys.exit(main(sys.argv[1], sys.argv[2]))
