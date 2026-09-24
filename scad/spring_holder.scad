plate_size = [77.5, 80];
baffle_width = 20;
extrusion_size = 15;

extrusion_center_offset = plate_size[0] / 2 - baffle_width / 2;
distance_between_outside_faces_of_extrusions = 2 * extrusion_center_offset + extrusion_size;

hammer_extrusion_play = 1;
m3_hole_radius = 3.2 / 2;
m3_groove_diameter = 6.5;

spring_holder_height = 34;
spring_holder_thickness = 20;
spring_holder_top_wall = 8;
spring_holder_corner_radius = 10;
spring_holder_cutout_corner_radius = spring_holder_corner_radius;
spring_groove_size = 9;
spring_groove_depth = 2.5;
spring_holder_screw_length = 30;
spring_holder_screw_extra_for_nut = 4;

use <../../../../lib/utils.scad>

module spring_holder(height = spring_holder_height) {
    w = distance_between_outside_faces_of_extrusions;
    r = spring_holder_corner_radius;
    cut_width = extrusion_size + hammer_extrusion_play;
    cut_height = height - spring_holder_top_wall;
    cut_x = (w - cut_width) / 2;
    cr = spring_holder_cutout_corner_radius;
    screw_groove_depth = max(0, (height - spring_holder_screw_length + spring_holder_screw_extra_for_nut));
    echo(screw_groove_depth);

    difference() {
        linear_extrude(height = spring_holder_thickness) {
            union() {
                difference() {
                    // Main body
                    square([w, height]);
                    translate([0, height - r]) square([r, r]);
                    translate([w - r, height - r]) square([r, r]);

                    // Cutout
                    translate([cut_x, 0]) square([cut_width, cut_height]);
                    translate([cut_x - cr, 0]) square([cr, cr]);
                    translate([cut_x + cut_width, 0]) square([cr, cr]);
                }
                quarter_round([r, height - r], 1, r);
                quarter_round([w - r, height - r], 0, r);
                quarter_round([cut_x - cr, cr], 3, cr);
                quarter_round([cut_x + cut_width + cr, cr], 2, cr);
            }
        }
        // Spring groove
        translate([cut_x + cut_width / 2, cut_height + spring_groove_depth / 2, spring_holder_thickness / 2])
            rotate([90, 0, 0])
                cylinder(h = spring_groove_depth + 0.01, r = spring_groove_size / 2, $fn = 48);

        // M3 mounting holes at extrusion centers
        for (hole_x = [extrusion_size / 2, w - extrusion_size / 2]) {
            translate([hole_x, height / 2, spring_holder_thickness / 2])
                rotate([90, 0, 0]) {
                    cylinder(h = height + 0.01, r = m3_hole_radius, center = true, $fn = 32);
                }
            translate([hole_x, height + 0.01, spring_holder_thickness / 2])
                rotate([90, 0, 0])
                    cylinder(h = screw_groove_depth + 0.01, r = m3_groove_diameter / 2, $fn = 48);
        }
    }
}

spring_holder();
