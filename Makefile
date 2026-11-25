# Build the printable STLs in models/ from the OpenSCAD sources in scad/.
#
#   make            re-export any STL whose sources changed
#   make -B         re-export every STL
#   make check      render everything (parts + thruster.scad assembly) and fail on any warning
#   make clean      remove the generated STLs
#
# Parts are exported with --hardwarnings, so a missing include, unknown
# variable/module or non-manifold result fails the build instead of silently
# producing a broken STL.
#
# thruster.scad needs the BOLTS library on the OpenSCAD library path. Its
# warnings come from inside BOLTS, so `make check` ignores warnings whose
# source file is under an OpenSCAD libraries/ directory.

OPENSCAD ?= openscad

PARTS := backstop base hammer_head hammer_holder hammer_joint \
         pedal_connector spring_holder washer
# Variants built from one source with -D overrides (rules below)
VARIANTS := hammer_holder_nut plunger plunger_with_disc
STLS  := $(PARTS:%=models/%.stl) $(VARIANTS:%=models/%.stl)

# Every part depends on the shared config and libs
COMMON := scad/config.scad $(wildcard scad/lib/*.scad)

.PHONY: all check check-assembly clean

all: $(STLS)

models/%.stl: scad/%.scad $(COMMON)
	$(OPENSCAD) --hardwarnings -q -o $@ $<

models/hammer_holder_nut.stl: scad/hammer_holder.scad $(COMMON)
	$(OPENSCAD) --hardwarnings -q -D m5_nut_side=true -o $@ $<

# Default plunger: solid TPU, metal plate stuck to the back
models/plunger.stl: scad/plunger.scad $(COMMON)
	$(OPENSCAD) --hardwarnings -q -D disc_indent_enabled=false -o $@ $<

# Optional plunger: pocket + snap lip for the 40 mm metal disc
models/plunger_with_disc.stl: scad/plunger.scad $(COMMON)
	$(OPENSCAD) --hardwarnings -q -D disc_indent_enabled=true -o $@ $<

check: all check-assembly

check-assembly:
	@tmp=$$(mktemp --suffix=.stl); \
	out=$$($(OPENSCAD) --backend=manifold -o $$tmp thruster.scad 2>&1); status=$$?; rm -f $$tmp; \
	warn=$$(printf '%s\n' "$$out" | grep -E 'WARNING|ERROR' | grep -v '/libraries/'); \
	if [ $$status -ne 0 ] || [ -n "$$warn" ]; then printf '%s\n' "$$out"; echo "thruster.scad: failed"; exit 1; fi; \
	echo "thruster.scad: OK"

clean:
	rm -f $(STLS)
