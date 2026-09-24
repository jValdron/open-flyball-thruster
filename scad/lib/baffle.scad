// Baffle Library
// Configurable parameters with defaults from base.scad

// Baffle dimensions
baffle_length = 80;
baffle_width = 19.9;
baffle_partial_arc_radius = 20;
baffle_thickness = 2;

// Baffle hole parameters
baffle_center_hole_radius = 3.25;
baffle_slot_width = 6.5;
baffle_slot_length = 15;
baffle_edge_offset = 2;

module rounded_slot(length, width) {
    slot_radius = width / 2;
    hull() {
        translate([0, length/2 - slot_radius, 0]) {
            circle(r = slot_radius, $fn = 64);
        }
        translate([0, -length/2 + slot_radius, 0]) {
            circle(r = slot_radius, $fn = 64);
        }
    }
}

// Baffle shape (2D profile)
module baffle_shape(
    length = baffle_length,
    width = baffle_width,
    arc_radius = baffle_partial_arc_radius
) {
    union() {
        square([length - baffle_partial_arc_radius * 2, width], center = true);

        baffle_arc_cap((length/2)-arc_radius, arc_radius, length, width);
        baffle_arc_cap(-(length/2)+arc_radius, arc_radius, length, width);
    }
}

// Helper function for an arc cap on the baffle
module baffle_arc_cap(x, arc_radius, length, width) {
    translate([x, 0, 0]) {
        intersection() {
            circle(r = arc_radius, $fn = 64);
            square([length, width], center = true);
        }
    }
}

// Baffle holes (for cutting into base or creating holes in baffle)
module baffle_holes(
    center_hole_radius = baffle_center_hole_radius,
    slot_width = baffle_slot_width,
    slot_length = baffle_slot_length,
    edge_offset = baffle_edge_offset,
    length = baffle_length,
    width = baffle_width,
    height = 10 // Default height for holes
) {
    // Center hole
    translate([0, 0, -0.5]) {
        cylinder(h = height + 1, r = center_hole_radius, $fn = 64);
    }

    // Top slot - positioned along X axis (width dimension) after rotation
    translate([length/2 - edge_offset - slot_length/2, 0, -0.5]) {
        linear_extrude(height = height + 1) {
            rotate([0, 0, -90]) {
                rounded_slot(slot_length, slot_width);
            }
        }
    }

    // Bottom slot - positioned along X axis (width dimension) after rotation
    translate([-length/2 + edge_offset + slot_length/2, 0, -0.5]) {
        linear_extrude(height = height + 1) {
            rotate([0, 0, -90]) {
                rounded_slot(slot_length, slot_width);
            }
        }
    }
}

// Complete baffle (3D solid)
module baffle(
    length = baffle_length,
    width = baffle_width,
    arc_radius = baffle_partial_arc_radius,
    thickness = baffle_thickness,
    center_hole_radius = baffle_center_hole_radius,
    slot_width = baffle_slot_width,
    slot_length = baffle_slot_length,
    edge_offset = baffle_edge_offset
) {
    difference() {
        // Baffle body
        linear_extrude(height = thickness) {
            rotate([0, 0, 90]) {
                baffle_shape(length, width, arc_radius);
            }
        }

        // Baffle holes
        rotate([0, 0, 90]) {
            baffle_holes(
                center_hole_radius = center_hole_radius,
                slot_width = slot_width,
                slot_length = slot_length,
                edge_offset = edge_offset,
                length = length,
                height = thickness
            );
        }
    }
}

