extrusion_size = 15;
hammer_size_extrusion_tolerance = 0.1;
hammer_side_extrusion_length = 135;
hammer_side_extrusion_short_length = 125;

pedal_connector_height = 20;
pedal_connector_wall = 2;
pedal_connector_bottom_wall = 6;
pedal_connector_bolt_cage_length = 12;
pedal_connector_bolt_cage_front_opening_x = 8.5;
pedal_connector_bolt_cage_front_opening_y = 12;
pedal_connector_bolt_cage_front_opening_corner_radius = 1.5;
pedal_connector_bolt_cage_window_width = 8;
pedal_connector_bolt_cage_window_height = 8;
pedal_connector_bolt_cage_window_corner_radius = 1.5;

pedal_connector_m3_hole_diameter = 3.2;
pedal_connector_m3_groove_diameter = 6.5;
pedal_connector_m3_groove_depth = 2.5;

hammer_side_cut_rise = hammer_side_extrusion_length - hammer_side_extrusion_short_length;
hammer_side_cut_angle = atan(hammer_side_cut_rise / extrusion_size);

pedal_connector_outer = extrusion_size + 2 * pedal_connector_wall;
extrusion_cavity_size = extrusion_size + 2 * hammer_size_extrusion_tolerance;
extrusion_cavity_offset = (pedal_connector_outer - extrusion_cavity_size) / 2;
pedal_connector_total_height = pedal_connector_height + hammer_side_cut_rise;
pedal_connector_bolt_cage_bottom_z = (hammer_side_cut_rise / extrusion_size) * pedal_connector_outer;
pedal_connector_bottom_wall_z = pedal_connector_bottom_wall / cos(hammer_side_cut_angle);

// Main body outer shell: box with angled bottom, same idea as cavity but size = outer and floor at z=0.
// Floor z = (cut_rise/extrusion_size)*y. Faces: Clockwise when viewed from outside.
module main_body_outer_polyhedron() {
    h = pedal_connector_total_height;
    floor_z_0 = 0;
    floor_z_1 = (hammer_side_cut_rise / extrusion_size) * pedal_connector_outer;
    w = pedal_connector_outer;
    points = [
        [0, 0, floor_z_0],         [w, 0, floor_z_0],
        [w, w, floor_z_1],         [0, w, floor_z_1],
        [0, 0, h],                 [w, 0, h],
        [w, w, h],                 [0, w, h]
    ];
    faces = [
        [0, 1, 2, 3],   // bottom (angled)
        [4, 5, 6, 7],   // top
        [0, 1, 5, 4],   // front y=0
        [1, 2, 6, 5],   // right x=w
        [2, 3, 7, 6],   // back y=w
        [3, 0, 4, 7]    // left x=0
    ];
    polyhedron(points = points, faces = faces, convexity = 4);
}

// Extrusion cavity: same structure as outer but extrusion_cavity_size (extrusion + tolerance) and floor raised by bottom_wall_z.
// Floor z = bottom_wall_z + (cut_rise/extrusion_size)*y. Faces: Clockwise when viewed from outside.
module extrusion_cavity_polyhedron() {
    h = pedal_connector_total_height + 0.02;
    floor_z_0 = pedal_connector_bottom_wall_z;
    floor_z_1 = pedal_connector_bottom_wall_z + (hammer_side_cut_rise / extrusion_size) * extrusion_cavity_size;
    points = [
        [0, 0, floor_z_0],                         [extrusion_cavity_size, 0, floor_z_0],
        [extrusion_cavity_size, extrusion_cavity_size, floor_z_1], [0, extrusion_cavity_size, floor_z_1],
        [0, 0, h],                                  [extrusion_cavity_size, 0, h],
        [extrusion_cavity_size, extrusion_cavity_size, h],  [0, extrusion_cavity_size, h]
    ];
    faces = [
        [0, 1, 2, 3],   // bottom (angled): CW from below => normal down, outward
        [4, 5, 6, 7],   // top
        [0, 1, 5, 4],   // front y=0
        [1, 2, 6, 5],   // right
        [2, 3, 7, 6],   // back
        [3, 0, 4, 7]    // left
    ];
    polyhedron(points = points, faces = faces, convexity = 4);
}

module bolt_cage_window_cut(wall, win_w, win_h, win_r) {
    rotate([0, 90, 0])
        linear_extrude(wall + 0.02, center = true)
            minkowski() {
                square([win_h - 2 * win_r, win_w - 2 * win_r], center = true);
                circle(r = win_r, $fn = 24);
            }
}

module pedal_connector() {
    union() {
        // Main body: outer shell polyhedron (angled bottom) minus extrusion cavity and holes
        difference() {
            main_body_outer_polyhedron();

            translate([extrusion_cavity_offset, extrusion_cavity_offset, 0]) {
                extrusion_cavity_polyhedron();
            }

            // Open main body to bolt cage: extend through full cavity depth so no lip (bolt cage cavity continues through)
            extrusion_cavity_short_side_z = pedal_connector_bottom_wall_z + (hammer_side_cut_rise / extrusion_size) * extrusion_cavity_size;
            opening_y_length = pedal_connector_outer - extrusion_cavity_offset;
            translate([extrusion_cavity_offset, extrusion_cavity_offset, extrusion_cavity_short_side_z]) {
                cube([
                    extrusion_cavity_size,
                    opening_y_length,
                    pedal_connector_total_height - extrusion_cavity_short_side_z
                ]);
            }

            hole_xy = pedal_connector_outer / 2;
            translate([hole_xy, hole_xy, -0.01]) {
                cylinder(h = pedal_connector_total_height + 0.02, d = pedal_connector_m3_hole_diameter, $fn = 32);
            }
            groove_z_start = (hammer_side_cut_rise / extrusion_size) * hole_xy;
            translate([hole_xy, hole_xy, -0.01]) {
                cylinder(
                    h = groove_z_start + pedal_connector_m3_groove_depth + 0.01,
                    d = pedal_connector_m3_groove_diameter,
                    $fn = 48
                );
            }
        }

        // Bolt cage
        translate([0, extrusion_cavity_offset + extrusion_cavity_size, pedal_connector_bolt_cage_bottom_z]) {
            bolt_cage_x = pedal_connector_outer;
            bolt_cage_y = pedal_connector_bolt_cage_length + pedal_connector_wall;
            bolt_cage_z = pedal_connector_total_height - pedal_connector_bolt_cage_bottom_z;
            w = pedal_connector_wall;
            difference() {
                cube([bolt_cage_x, bolt_cage_y, bolt_cage_z]);
                translate([extrusion_cavity_offset, 0, pedal_connector_wall]) {
                    cube([
                        extrusion_cavity_size,
                        bolt_cage_y - w,
                        bolt_cage_z - pedal_connector_wall - w
                    ]);
                }
                // Windows in the two sides
                win_w = pedal_connector_bolt_cage_window_width;
                win_h = pedal_connector_bolt_cage_window_height;
                win_r = min(pedal_connector_bolt_cage_window_corner_radius, win_w / 2, win_h / 2);
                win_y = (bolt_cage_y - win_w) / 2;
                win_z = (bolt_cage_z - win_h) / 2;
                translate([w / 2, win_y + win_w / 2, win_z + win_h / 2])
                    bolt_cage_window_cut(w, win_w, win_h, win_r);
                translate([bolt_cage_x - w / 2, win_y + win_w / 2, win_z + win_h / 2])
                    bolt_cage_window_cut(w, win_w, win_h, win_r);

                // Front opening
                front_open_x = pedal_connector_bolt_cage_front_opening_x;
                front_open_y = pedal_connector_bolt_cage_front_opening_y;
                front_open_r = min(
                    pedal_connector_bolt_cage_front_opening_corner_radius,
                    front_open_x / 2,
                    front_open_y / 2
                );
                translate([bolt_cage_x / 2, bolt_cage_y - w / 2, bolt_cage_z / 2]) {
                    rotate([90, 0, 0]) {
                        linear_extrude(w + 0.02, center = true) {
                            minkowski() {
                                square([front_open_x - 2 * front_open_r, front_open_y - 2 * front_open_r], center = true);
                                circle(r = front_open_r, $fn = 24);
                            }
                        }
                    }
                }
            }
        }
    }
}

pedal_connector();
