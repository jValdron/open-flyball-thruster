plunger_radius = 24;
plunger_thickness = 10;
plunger_fillet = 2;
plunger_hole_radius = 2;
m4_flange_radius = 5;

module plunger() {
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

