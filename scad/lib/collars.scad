// Collars and shaft couplings for linear rods

stop_collar_id = 8;
stop_collar_od = 14;
stop_collar_thickness = 7;
m4_tap_radius = 1.65;
m4_grub_screw_length = 5;

module m4_grub_screw(length = m4_grub_screw_length) {
    cylinder(h = length, r = 2, $fn = 24);
}

module stop_collar(
    id = stop_collar_id,
    od = stop_collar_od,
    thickness = stop_collar_thickness,
    grub_screw_radius = m4_tap_radius
) {
    difference() {
        // Main body
        cylinder(h = thickness, d = od, $fn = 64);
        translate([0, 0, -0.01]) {
            cylinder(h = thickness + 0.02, d = id, $fn = 64);
        }

        // M4 grub screw hole (blind, from one face only)
        translate([0, 0, thickness / 2]) {
            rotate([-90, 0, 0]) {
                translate([0, 0, -od / 2]) {
                    cylinder(h = od / 2 + id / 2 + 0.5, r = grub_screw_radius, $fn = 32);
                }
            }
        }
    }
}

// Shaft coupling (e.g. T8: 8mm ID, 14mm OD)
shaft_coupling_id = 8;
shaft_coupling_od = 14;
shaft_coupling_length = 22;

module shaft_coupling(
    id = shaft_coupling_id,
    od = shaft_coupling_od,
    length = shaft_coupling_length,
    grub_screw_radius = m4_tap_radius
) {
    difference() {
        cylinder(h = length, d = od, $fn = 64);
        translate([0, 0, -0.01]) {
            cylinder(h = length + 0.02, d = id, $fn = 64);
        }

        // 4× M4 grub screw holes
        hole_z_positions = [length / 4, 3 * length / 4];
        for (angle = [0, 90]) {
            rotate([0, 0, angle]) {
                for (z_pos = hole_z_positions) {
                    translate([0, 0, z_pos]) {
                        rotate([-90, 0, 0]) {
                            translate([0, 0, -od / 2]) {
                                cylinder(h = (od - id) / 2 + 0.5, r = grub_screw_radius, $fn = 32);
                            }
                        }
                    }
                }
            }
        }
    }
}
