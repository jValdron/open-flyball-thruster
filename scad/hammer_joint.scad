use <lib/utils.scad>

extrusion_size = 15;

hammer_head_height = 6;
hammer_head_height_offset = 4.5;
hammer_top_extrusion_offset = 3;

hammer_joint_wall = 3;
hammer_joint_bottom_offset = 6;
hammer_joint_right_offset = 8;
hammer_joint_corner_radius = 3;

m3_hole_radius = 3.2 / 2;
m3_groove_diameter = 6.5;
m3_groove_depth = 0.5;

top_z = hammer_joint_bottom_offset + extrusion_size + hammer_top_extrusion_offset + hammer_joint_wall + hammer_head_height_offset;
top_edge_y_max = extrusion_size + hammer_joint_wall * 2;

module top_edge_fillet(r, length, quadrant_y) {
    intersection() {
        rotate([0, 90, 0])
            cylinder(h = length + 0.02, r = r, center = false, $fn = 32);
        if (quadrant_y < 0) {
            translate([0, -100, 0]) cube([length + 0.02, 100, 100]);
        } else {
            cube([length + 0.02, 100, 100]);
        }
    }
}

module hammer_joint() {
    union() {
        // Main piece
        difference() {
            cube([
                extrusion_size,
                extrusion_size + hammer_joint_wall * 2,
                top_z - hammer_joint_wall
            ]);

            // Extrusion-sized hole: wall on both sides, wall + hammer_head_height_offset on top
            translate([-0.01, hammer_joint_wall, -0.01]) {
                cube([extrusion_size + 0.02, extrusion_size, hammer_joint_bottom_offset + extrusion_size + hammer_top_extrusion_offset]);
            }
            translate([-0.01, hammer_joint_wall, hammer_joint_bottom_offset + hammer_top_extrusion_offset + hammer_joint_wall + extrusion_size + 0.01]) {
                cube([extrusion_size + 0.02, extrusion_size, hammer_head_height_offset]);
            }

            // Cut bottom corners
            r = hammer_joint_corner_radius;
            translate([-0.01, -0.01, -0.01])
                cube([r, hammer_joint_wall + 0.02, r]);
            translate([extrusion_size - r + 0.01, -0.01, -0.01])
                cube([r, hammer_joint_wall + 0.02, r]);
            translate([-0.01, top_edge_y_max - r - 0.01, -0.01])
                cube([r, hammer_joint_wall + 0.02, r]);
            translate([extrusion_size - r + 0.01, top_edge_y_max - r - 0.01, -0.01])
                cube([r, hammer_joint_wall + 0.02, r]);

            // M3 hole at top center
            translate([extrusion_size / 2, top_edge_y_max / 2, -0.01])
                cylinder(h = top_z + 0.02, r = m3_hole_radius, $fn = 32);

            // M3 holes on each side face
            side_hole_z = hammer_joint_bottom_offset + extrusion_size / 2;
            translate([extrusion_size / 2, -0.01, side_hole_z]) {
                rotate([-90, 0, 0]) {
                    cylinder(h = hammer_joint_wall + 0.02, r = m3_hole_radius, $fn = 32);
                    cylinder(h = m3_groove_depth + 0.01, r = m3_groove_diameter / 2, $fn = 32);
                }
            }
            translate([extrusion_size / 2, top_edge_y_max + 0.01, side_hole_z]) {
                rotate([90, 0, 0]) {
                    cylinder(h = hammer_joint_wall + 0.02, r = m3_hole_radius, $fn = 32);
                    cylinder(h = m3_groove_depth + 0.01, r = m3_groove_diameter / 2, $fn = 32);
                }
            }
        }
        // Side piece
        translate([extrusion_size, 0, hammer_joint_bottom_offset]) {
            difference() {
                cube([
                    hammer_joint_right_offset,
                    extrusion_size + hammer_joint_wall * 2,
                    extrusion_size
                ]);
                translate([-0.01, hammer_joint_wall, -0.01]) {
                    cube([hammer_joint_right_offset + 0.02, extrusion_size, extrusion_size + 0.02]);
                }
                // Cut side corners
                r = hammer_joint_corner_radius;
                translate([hammer_joint_right_offset - r, -0.01, -0.01])
                    cube([r + 0.02, r + 0.02, r]);
                translate([hammer_joint_right_offset - r, top_edge_y_max - r - 0.01, -0.01])
                    cube([r + 0.02, r + 0.02, r]);
                translate([hammer_joint_right_offset - r, -0.01, extrusion_size - r])
                    cube([r + 0.02, r + 0.02, r + 0.01]);
                translate([hammer_joint_right_offset - r, top_edge_y_max - r - 0.01, extrusion_size - r])
                    cube([r + 0.02, r + 0.02, r + 0.01]);

                // M3 hole on each side face
                translate([hammer_joint_right_offset / 2, -0.01, extrusion_size / 2]) {
                    rotate([-90, 0, 0]) {
                        cylinder(h = hammer_joint_wall + 0.02, r = m3_hole_radius, $fn = 32);
                        cylinder(h = m3_groove_depth + 0.01, r = m3_groove_diameter / 2, $fn = 32);
                    }
                }
                translate([hammer_joint_right_offset / 2, top_edge_y_max + 0.01, extrusion_size / 2]) {
                    rotate([90, 0, 0]) {
                        cylinder(h = hammer_joint_wall + 0.02, r = m3_hole_radius, $fn = 32);
                        cylinder(h = m3_groove_depth + 0.01, r = m3_groove_diameter / 2, $fn = 32);
                    }
                }
            }
            // Round side corners
            r = hammer_joint_corner_radius;
            translate([hammer_joint_right_offset - r, r, r])
                rotate([90, 90, 0])
                    linear_extrude(r)
                        quarter_round([0, 0], 0, r);
            translate([hammer_joint_right_offset - r, top_edge_y_max, r])
                rotate([90, 0, 0])
                    linear_extrude(r)
                        quarter_round([0, 0], 3, r);
            translate([hammer_joint_right_offset - r, r, extrusion_size - r])
                rotate([90, 90, 0])
                    linear_extrude(r)
                        quarter_round([0, 0], 1, r);
            translate([hammer_joint_right_offset - r, top_edge_y_max, extrusion_size - r])
                rotate([90, 180, 0])
                    linear_extrude(r)
                        quarter_round([0, 0], 2, r);
        }
        // Round off the two outer top edges (around the hammer head)
        translate([0, hammer_joint_wall, top_z - hammer_joint_wall]) {
            top_edge_fillet(hammer_joint_wall, extrusion_size, -1);
        }
        translate([0, top_edge_y_max - hammer_joint_wall, top_z - hammer_joint_wall]) {
            top_edge_fillet(hammer_joint_wall, extrusion_size, 1);
        }
        // Round all 4 corners on the bottom
        r = hammer_joint_corner_radius;
        rotate([-90, 90, 0])
            linear_extrude(hammer_joint_corner_radius)
                quarter_round([-r, -r], 0, r);
        translate([extrusion_size, 0, 0])
            rotate([-90, -90, 0])
                linear_extrude(hammer_joint_corner_radius)
                    quarter_round([r, -r], 1, r);
        translate([0, top_edge_y_max, 0])
            rotate([90, 90, 0])
                linear_extrude(hammer_joint_corner_radius)
                    quarter_round([-r, r], 3, r);
        translate([extrusion_size, top_edge_y_max, 0])
            rotate([90, -90, 0])
                linear_extrude(hammer_joint_corner_radius)
                    quarter_round([r, r], 2, r);
        // Inner corner fillets
        translate([extrusion_size + r, r, hammer_joint_bottom_offset])
            rotate([90, 180, 0])
                linear_extrude(r)
                    difference() {
                        square([r, r]);
                        translate([0, r]) circle(r = r, $fn = 32);
                    }
        translate([extrusion_size, top_edge_y_max - r, hammer_joint_bottom_offset])
            rotate([-90, 0, 0])
                linear_extrude(r)
                    difference() {
                        square([r, r]);
                        translate([r, r]) circle(r = r, $fn = 32);
                    }
        translate([extrusion_size + r, r, hammer_joint_bottom_offset + extrusion_size])
            rotate([90, -90, 0])
                linear_extrude(r)
                    difference() {
                        square([r, r]);
                        translate([r, 0]) circle(r = r, $fn = 32);
                    }
        translate([extrusion_size, top_edge_y_max - r, hammer_joint_bottom_offset + extrusion_size + r])
            rotate([-90, 0, 0])
                linear_extrude(r)
                    difference() {
                        square([r, r]);
                        translate([r, 0]) circle(r = r, $fn = 32);
                    }
    }
}

hammer_joint();
