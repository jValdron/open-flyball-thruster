hammer_holder_wall = 6;
hammer_holder_depth = 12;
hammer_extrusion_play = 1;
hardware_holder_height = 14;
corner_radius = hammer_holder_wall / 2;
inner_corner_radius = 5;

plate_size = [77.5, 80];
baffle_width = 20;
extrusion_size = 15;

extrusion_center_offset = plate_size[0] / 2 - baffle_width / 2;
distance_between_outside_faces_of_extrusions = 2 * extrusion_center_offset + extrusion_size;

m3_hole_radius = 3.2 / 2;
m3_groove_diameter = 6.5;
m3_groove_depth = 1;

m5_hole_radius = 5.2 / 2;
m5_groove_diameter = 10;
m5_groove_depth = 1.5;

// M5 hinge: true = groove for hex nut side, false = groove for screw head
m5_nut_side = false;
m5_nut_flat = 8;
m5_nut_depth = 4;

use <../../../../lib/utils.scad>

module hammer_holder(nut_side = undef) {
    _m5_nut = (nut_side != undef) ? nut_side : m5_nut_side;
    extra_width_required = extrusion_center_offset - extrusion_size - hammer_holder_wall - hammer_extrusion_play / 2;
    total_width = hammer_holder_wall + extrusion_size + extra_width_required + hammer_holder_wall;
    total_height = extrusion_size + hammer_holder_wall + hardware_holder_height;

    difference() {
        linear_extrude(height = hammer_holder_depth) {
            union() {
                // Main profile
                difference() {
                    difference() {
                        square([total_width, total_height]);
                        translate([total_width - extrusion_size - extra_width_required - hammer_holder_wall, total_height - extrusion_size])
                            square([extrusion_size + extra_width_required + hammer_holder_wall, extrusion_size]);
                        square([hammer_holder_wall + extrusion_size + extra_width_required, hardware_holder_height]);
                    }
                    // Cut off sharp corners
                    for (cut = [
                        [0, total_height - corner_radius],
                        [0, hardware_holder_height],
                        [total_width - corner_radius, hardware_holder_height + hammer_holder_wall - corner_radius],
                        [total_width - hammer_holder_wall, 0]
                    ]) {
                        translate(cut)
                            square([corner_radius, corner_radius]);
                    }
                }
                // Add quarter circles for rounded corners
                for (c = [
                    [corner_radius, total_height - corner_radius, 1],
                    [corner_radius, hardware_holder_height + corner_radius, 2],
                    [total_width - corner_radius, hardware_holder_height + hammer_holder_wall - corner_radius, 0],
                    [total_width - hammer_holder_wall + corner_radius, corner_radius, 2]
                ]) {
                    quarter_round([c[0], c[1]], c[2], corner_radius);
                }
                // Inner rounded corner
                translate([hammer_holder_wall + extrusion_size + extra_width_required - inner_corner_radius, hardware_holder_height - inner_corner_radius])
                    difference() {
                        square([inner_corner_radius, inner_corner_radius]);
                        circle(r = inner_corner_radius, $fn = 32);
                    }
            }
        }
        // M3 screws for fastening to extrusion [position, rotation]
        for (hole = [
            [[0 - 0.01, hardware_holder_height + hammer_holder_wall + extrusion_size / 2, hammer_holder_depth / 2], [90, 0, 90]],
            [[hammer_holder_wall + extrusion_size/2, hardware_holder_height - 0.01, hammer_holder_depth / 2], [-90, 0, 0]]
        ]) {
            translate(hole[0])
                rotate(hole[1]) {
                    cylinder(h = hammer_holder_depth + 1, r = m3_hole_radius, center = true, $fn = 32);
                    cylinder(h = m3_groove_depth, d = m3_groove_diameter, $fn = 48);
                }
        }
        // M5 through hole + groove (screw head or nut hex)
        translate([hammer_holder_wall + extrusion_size + extra_width_required - inner_corner_radius, hardware_holder_height / 2, hammer_holder_depth / 2])
            rotate([90, 0, 90]) {
                cylinder(h = hammer_holder_wall + inner_corner_radius + 0.01, r = m5_hole_radius, $fn = 32);
                if (_m5_nut) {
                    cylinder(h = m5_nut_depth + inner_corner_radius, r = m5_nut_flat / sqrt(3), $fn = 6);
                } else {
                    cylinder(h = m5_groove_depth + inner_corner_radius, d = m5_groove_diameter, $fn = 48);
                }
            }
    }
}

hammer_holder();
