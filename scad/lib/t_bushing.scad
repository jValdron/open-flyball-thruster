// T-shaped nylon bushing (e.g. TW-810/M8 style): flange + central body, 8mm bore

t_bushing_id = 8;
t_bushing_flange_od = 16;
t_bushing_flange_thickness = 3;
t_bushing_body_od = 10;
t_bushing_body_height = 5;

module t_bushing(
    id = t_bushing_id,
    flange_od = t_bushing_flange_od,
    flange_thickness = t_bushing_flange_thickness,
    body_od = t_bushing_body_od,
    body_height = t_bushing_body_height
) {
    // Bore through entire length
    total_height = flange_thickness + body_height;
    difference() {
        union() {
            // Flange (base)
            cylinder(h = flange_thickness, d = flange_od, $fn = 64);
            // Central body (on top of flange)
            translate([0, 0, flange_thickness]) {
                cylinder(h = body_height, d = body_od, $fn = 64);
            }
        }
        translate([0, 0, -0.01]) {
            cylinder(h = total_height + 0.02, d = id, $fn = 64);
        }
    }
}
