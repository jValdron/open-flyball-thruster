washer_inner_diameter = 8.5;
washer_outer_diameter = 14;
washer_height = 2;

module washer(
    inner_diameter = washer_inner_diameter,
    outer_diameter = washer_outer_diameter,
    height = washer_height
) {
    difference() {
        cylinder(h = height, d = outer_diameter, $fn = 64);
        translate([0, 0, -0.01]) {
            cylinder(h = height + 0.02, d = inner_diameter, $fn = 64);
        }
    }
}

washer();
