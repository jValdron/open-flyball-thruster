# Build the printable STLs in models/ from the OpenSCAD sources in scad/.
#
#   make            re-export any STL whose sources changed
#   make -B         re-export every STL
#   make check      build all parts and evaluate the thruster.scad assembly; fail on any warning
#   make verify     rebuild every STL and fail if its geometry differs from the committed one
#   make bolts      download the BOLTS library (needed by thruster.scad) into .bolts/
#   make clean      remove the generated STLs
#
# Parts are exported with --hardwarnings, so a missing include, unknown
# variable/module or non-manifold result fails the build instead of silently
# producing a broken STL.
#
# thruster.scad needs the BOLTS library, either installed in your OpenSCAD
# library folder or fetched with `make bolts`. BOLTS itself emits warnings, so
# `make check` ignores warnings whose source file is inside the BOLTS library.

OPENSCAD ?= openscad
PYTHON   ?= python3

BOLTS_VERSION := 0.4.1
BOLTS_SHA256  := 1b5656d984ef8019ff78ae5bfdf44baea5e2daab73e25c1e992d96dc8ae990b1
BOLTS_DIR     := .bolts
export OPENSCADPATH := $(CURDIR)/$(BOLTS_DIR)$(if $(OPENSCADPATH),:$(OPENSCADPATH))

PARTS := backstop base hammer_head hammer_holder hammer_joint \
         pedal_connector spring_holder washer
# Variants built from one source with -D overrides (rules below)
VARIANTS := hammer_holder_nut plunger plunger_with_disc
STLS  := $(PARTS:%=models/%.stl) $(VARIANTS:%=models/%.stl)

# Every part depends on the shared config and libs
COMMON := scad/config.scad $(wildcard scad/lib/*.scad)

.PHONY: all check check-assembly verify bolts clean

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

# Evaluating to CSG runs all the module/variable code (so unknown variables,
# modules and includes are reported) without the cost of a full render.
check-assembly:
	@tmp=$$(mktemp --suffix=.csg); \
	out=$$($(OPENSCAD) -o $$tmp thruster.scad 2>&1); status=$$?; rm -f $$tmp; \
	warn=$$(printf '%s\n' "$$out" | grep -E 'WARNING|ERROR' | grep -vE 'libraries/|$(BOLTS_DIR)/'); \
	if [ $$status -ne 0 ] || [ -n "$$warn" ]; then printf '%s\n' "$$out"; echo "thruster.scad: failed"; exit 1; fi; \
	echo "thruster.scad: OK"

# Geometry comparison rather than byte comparison: different OpenSCAD builds
# triangulate the same part differently.
verify:
	rm -rf build/committed
	mkdir -p build/committed
	cp models/*.stl build/committed/
	$(MAKE) -B all
	$(PYTHON) tools/compare_stls.py build/committed models

bolts: $(BOLTS_DIR)/BOLTS.scad

$(BOLTS_DIR)/BOLTS.scad:
	rm -rf $(BOLTS_DIR)
	mkdir -p $(BOLTS_DIR)
	curl -fsSL -o $(BOLTS_DIR)/boltsos.tar.gz \
		https://github.com/boltsparts/BOLTS/releases/download/v$(BOLTS_VERSION)/boltsos_$(BOLTS_VERSION).tar.gz
	echo "$(BOLTS_SHA256)  $(BOLTS_DIR)/boltsos.tar.gz" | sha256sum -c -
	tar -xzf $(BOLTS_DIR)/boltsos.tar.gz -C $(BOLTS_DIR) --warning=no-unknown-keyword
	rm $(BOLTS_DIR)/boltsos.tar.gz

clean:
	rm -f $(STLS)
	rm -rf build
