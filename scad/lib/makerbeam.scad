// MakerBeam XL 1515 Aluminum Extrusion
// https://cdn.webshopapp.com/shops/50353/files/471210975/20161130-overview-specifications-mb-mbxl-ob-with-p.jpg
module makerbeam_xl_1515(length) {
    module rounded_rect(width, height, radius) {
        if (radius > 0) {
            offset(r = radius, $fn = 32)
                square([width - radius * 2, height - radius * 2], center = true);
        } else {
            square([width, height], center = true);
        }
    }

    module opening_shape(width, height, radius) {
        hull() {
            translate([-width/2, height/2])
                square([0.01, 0.01], center = true);
            translate([width/2, height/2])
                square([0.01, 0.01], center = true);

            translate([-width/2 + radius, -height/2 + radius])
                if (radius > 0) circle(r = radius, $fn = 32);
                else square([0.01, 0.01], center = true);
            translate([width/2 - radius, -height/2 + radius])
                if (radius > 0) circle(r = radius, $fn = 32);
                else square([0.01, 0.01], center = true);
        }
    }

    module t_slot(side) {
        opening_width = 3;
        opening_height = 5;
        cavity_offset = 1.1;
        cavity_width = 5.7;
        cavity_depth = 2.5;
        corner_radius = 0.25;

        edge_pos = 7.5;

        rotate([0, 0, side * 90]) {
            union() {
                translate([0, edge_pos - opening_height / 2])
                    opening_shape(opening_width, opening_height, corner_radius);

                translate([0, edge_pos - cavity_offset - cavity_depth / 2])
                    rounded_rect(cavity_width, cavity_depth, corner_radius);
            }
        }
    }

    module profile() {
        corner_radius = 0.25;

        difference() {
            offset(r = corner_radius, $fn = 32)
                square([15 - corner_radius * 2, 15 - corner_radius * 2], center = true);

            // T-slots on all 4 sides with rounded edges
            // 0=top, 1=right, 2=bottom, 3=left
            for (side = [0:3]) {
                t_slot(side);
            }

            // Round holes
            hole_diameter = 2.55;
            hole_spacing = 10;

            // Center hole
            circle(d = hole_diameter, $fn = 32);

            // Corner holes
            corner_offset = hole_spacing / 2;
            for (x = [-1, 1], y = [-1, 1]) {
                translate([x * corner_offset, y * corner_offset])
                    circle(d = hole_diameter, $fn = 32);
            }
        }
    }

    linear_extrude(height = length, center = false)
        profile();
}

