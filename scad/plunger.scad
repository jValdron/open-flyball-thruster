include <config.scad>

plunger_radius = 24;
plunger_fillet = 2;
plunger_hole_radius = 2;
m4_flange_radius = 5;

// Metal disc seated in base (40 mm diameter × 8 mm thick)
disc_indent_enabled = true;
disc_indent_radius = 20;
disc_indent_depth = 8;
disc_indent_clearance = 0;
disc_lip_height = 0.8;
disc_lip_inward = 0.75;

module plunger(enable_disc_indent = disc_indent_enabled) {
    difference() {
        union() {
            // Main cylinder
            cylinder(h = plunger_thickness - plunger_fillet, r = plunger_radius, $fn = 64);

            // Rounded fillet on top edge
            translate([0, 0, plunger_thickness - plunger_fillet]) {
                rotate_extrude($fn = 64) {
                    translate([plunger_radius - plunger_fillet, 0, 0]) {
                        circle(r = plunger_fillet, $fn = 32);
                    }
                }
            }

            // Top flat surface
            translate([0, 0, plunger_thickness - plunger_fillet]) {
                cylinder(h = plunger_fillet, r = plunger_radius - plunger_fillet, $fn = 64);
            }

            if (enable_disc_indent) {
                // Snap lip over disc edge, full width to plunger OD (below base face)
                translate([0, 0, -disc_lip_height]) {
                    difference() {
                        cylinder(h = disc_lip_height, r = plunger_radius, $fn = 64);
                        cylinder(h = disc_lip_height + 0.2, r = disc_indent_radius - disc_lip_inward, $fn = 64);
                    }
                }
            }
        }

        if (enable_disc_indent) {
            // Pocket from base face upward; lip below z=0 is not cut
            translate([0, 0, 0]) {
                cylinder(
                    h = disc_indent_depth + disc_indent_clearance + 0.01,
                    r = disc_indent_radius + disc_indent_clearance,
                    $fn = 64
                );
            }
        }

        // Center hole
        translate([0, 0, -0.5]) {
            cylinder(h = plunger_thickness + 1, r = plunger_hole_radius, $fn = 64);
        }

        // M4 countersunk chamfer
        m4_countersink_head_radius = 4.2;
        m4_countersink_depth = 3.0;
        translate([0, 0, plunger_thickness - m4_countersink_depth]) {
            cylinder(h = m4_countersink_depth + 0.5, r1 = plunger_hole_radius, r2 = m4_countersink_head_radius, $fn = 64);
        }
    }
}

plunger();

