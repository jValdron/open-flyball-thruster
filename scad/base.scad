include <config.scad>
use <lib/baffle.scad>

m3_countersink_head_radius = 3;
m3_countersink_depth = 2;

module base() {
    difference() {
        // Base plate
        linear_extrude(height = plate_thickness) {
            union() {
                square([plate_size[0]-baffle_partial_arc_radius, plate_size[1]], center = true);

                for (side = [-1, 1]) {
                    translate([side * (plate_size[0]/2 - baffle_partial_arc_radius/2), 0, 0]) {
                        rotate([0, 0, 90]) {
                            baffle_shape(baffle_length, baffle_width, baffle_partial_arc_radius);
                        }
                    }
                }
            }
        }

        // Linear shaft hole
        translate([0, 0, -0.5]) {
            cylinder(h = plate_thickness + 1, r = linear_shaft_hole_radius, $fn = 64);
        }

        // Baffle recesses and holes - mirrored left and right
        baffle_recess_clearance = 0.1;
        baffle_x_offset = plate_size[0]/2 - baffle_width/2 + baffle_recess_clearance;

        for (side = [-1, 1]) {
            baffle_x = side * baffle_x_offset;

            // Baffle recess - with clearance
            translate([baffle_x, 0, plate_thickness - baffle_thickness - baffle_recess_clearance]) {
                linear_extrude(height = baffle_thickness + baffle_recess_clearance + 0.5) {
                    rotate([0, 0, 90]) {
                        baffle_shape();
                    }
                }
            }

            // Baffle holes
            translate([baffle_x, 0, 0]) {
                rotate([0, 0, 90]) {
                    baffle_holes(
                        center_hole_radius = m3_hole_radius,
                        slot_width = baffle_slot_width,
                        slot_length = baffle_slot_length,
                        edge_offset = baffle_edge_offset,
                        length = baffle_length,
                        height = plate_thickness
                    );
                }
            }

            // Baffle center hole chamfer
            translate([baffle_x, 0, -0.5]) {
                cylinder(h = m3_countersink_depth + 1, r1 = m3_countersink_head_radius, r2 = m3_hole_radius, $fn = 64);
            }
        }
    }
}

base();

