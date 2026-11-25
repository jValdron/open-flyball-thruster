// Compression spring: axis along Z, centered at origin
// OD = outer diameter, wire_d = wire diameter, length = free length
// Defaults to the main spring.
include <../config.scad>

module compression_spring(
    od = main_spring_od,
    wire_d = main_spring_wire_d,
    length = main_spring_length
) {
    coil_radius = (od - wire_d) / 2;
    pitch = wire_d * 2.5;
    slices = max(400, round(length / 0.5));
    linear_extrude(height = length, twist = -360 * length / pitch, slices = slices) {
        translate([coil_radius, 0, 0]) {
            circle(d = wire_d, $fn = 64);
        }
    }
}