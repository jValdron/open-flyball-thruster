// Quarter circle at center; quadrant 0=+x+y, 1=-x+y, 2=-x-y, 3=+x-y
module quarter_round(center, quadrant, corner_radius) {
    translate(center)
        intersection() {
            circle(r = corner_radius, $fn = 32);
            if (quadrant == 0) square([corner_radius, corner_radius]);
            if (quadrant == 1) translate([-corner_radius, 0]) square([corner_radius, corner_radius]);
            if (quadrant == 2) translate([-corner_radius, -corner_radius]) square([corner_radius, corner_radius]);
            if (quadrant == 3) translate([0, -corner_radius]) square([corner_radius, corner_radius]);
        }
}
