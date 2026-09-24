backstop_height = 25;
backstop_thickness = 8;
corner_radius = 5;

plate_size = [77.5, 80];
baffle_width = 20;
extrusion_size = 15;

extrusion_center_offset = plate_size[0] / 2 - baffle_width / 2;
backstop_width = 2 * extrusion_center_offset + extrusion_size;

extrusion_groove_size = extrusion_size + 0.1;
extrusion_groove_depth = 1;

linear_shaft_hole_radius = 5;
linear_shaft_groove_radius = 8;
linear_shaft_groove_depth = 2;
m3_hole_radius = 3.2 / 2;

module backstop() {
    difference() {
        // Main body
        linear_extrude(height = backstop_thickness) {
            minkowski() {
                square([backstop_width - 2 * corner_radius, backstop_height - 2 * corner_radius], center = true);
                circle(r = corner_radius, $fn = 64);
            }
        }

        // Linear shaft hole (centre)
        translate([0, 0, -0.5]) {
            cylinder(h = backstop_thickness + 1, r = linear_shaft_hole_radius, $fn = 64);
        }

        // Two M3 screw holes at extrusion centres
        for (side = [-1, 1]) {
            translate([side * extrusion_center_offset, 0, -0.5]) {
                cylinder(h = backstop_thickness + 1, r = m3_hole_radius, $fn = 32);
            }
        }

        // Groves on the face that mates with the extrusions
        for (side = [-1, 1]) {
            translate([side * extrusion_center_offset, 0, backstop_thickness - extrusion_groove_depth]) {
                linear_extrude(height = extrusion_groove_depth + 0.5) {
                    square([extrusion_groove_size, extrusion_groove_size], center = true);
                }
            }
        }

        // Circular groove around shaft
        translate([0, 0, backstop_thickness - linear_shaft_groove_depth]) {
            cylinder(h = linear_shaft_groove_depth + 0.5, r = linear_shaft_groove_radius, $fn = 64);
        }
    }
}

backstop();
