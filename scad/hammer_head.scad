extrusion_size = 15;
m3_hole_radius = 3.2 / 2;
m3_countersink_diameter = 6;
m3_countersink_depth = 1.5;

hammer_head_height = 6;

module hammer_head() {
    difference() {
        cube([extrusion_size, extrusion_size, hammer_head_height]);
        // M3 hole
        translate([extrusion_size / 2, extrusion_size / 2, -0.01]) {
            cylinder(h = hammer_head_height + 0.02, r = m3_hole_radius, $fn = 32);
        }
        // Countersink
        translate([extrusion_size / 2, extrusion_size / 2, hammer_head_height - m3_countersink_depth]) {
            cylinder(h = m3_countersink_depth + 0.02, r1 = m3_hole_radius, r2 = m3_countersink_diameter / 2, $fn = 32);
        }
    }
}

// Placed hammer head (color + translate) for use from thruster.scad
module hammer_head_placed(tx, ty, tz, top_edge_y, extrusion_size_val, head_color) {
    color(head_color) {
        translate([
            tx - top_edge_y / 2 - extrusion_size_val / 2,
            ty,
            tz
        ]) {
            hammer_head();
        }
    }
}

hammer_head();
