include <scad/config.scad>

use <scad/lib/makerbeam.scad>
use <scad/lib/baffle.scad>
use <scad/lib/collars.scad>
use <scad/lib/t_bushing.scad>
use <scad/lib/compression_spring.scad>

use <BOLTS.scad>

use <scad/base.scad>
use <scad/backstop.scad>
use <scad/plunger.scad>
use <scad/hammer_holder.scad>
use <scad/hammer_joint.scad>
use <scad/hammer_head.scad>
use <scad/spring_holder.scad>
use <scad/pedal_connector.scad>

// Shared dimensions come from scad/config.scad. Values below only affect
// where things are placed in this assembly view.

petg_color = [0.929, 0.0, 0.549];
extrusion_color = [0.12, 0.12, 0.12];
steel_color = [0.65, 0.65, 0.7];
anodized_steel_color = [0.15, 0.15, 0.15];
tpu_color = [0.05, 0.05, 0.05];
nylon_color = [0.35, 0.35, 0.38];

hammer_holder_backstop_offset = 8;
hammer_holder_x_offset = extrusion_size / 2 + hammer_holder_wall;
hammer_holder_total_height = extrusion_size + hammer_holder_wall + hardware_holder_height;
hammer_holder_clearance_below_center = 10;
hammer_holder_z_offset = hammer_holder_total_height / 2 + hammer_holder_clearance_below_center;
hammer_top_extrusion_m5_through_hole_d = 6.5;
hammer_top_extrusion_spring_holder_hole_d = 9;
hammer_top_extrusion_spring_holder_hole_offset = 20;
pedal_connector_z_offset = 15;
pedal_connector_m6_bolt_length = 40;
pedal_connector_m6_head_inset = 6;  // M6 head position past the end of the extrusion cavity

spring_holder_y_offset = 52.5;

linear_shaft_length = 200;
linear_shaft_extension = 40;
m4_tap_depth = 15;

plunger_disc_thickness = 8;
plunger_disc_radius = 20;
m4_screw_length = 20;

// Base plate
color(petg_color) {
    rotate([-90, 0, 0]) {
        base();
    }
}

// T-bushing in base plate
color(nylon_color) {
    translate([0, plate_thickness + t_bushing_flange_thickness, 0]) {
        rotate([90, 0, 0]) {
            t_bushing();
        }
    }
}

// Linear shaft
color(steel_color) {
    translate([0, -linear_shaft_extension, 0]) {
        rotate([-90, 0, 0]) {
            difference() {
                // Rod
                cylinder(h = linear_shaft_length, r = 4, $fn = 64);

                // Tapped M4 hole
                translate([0, 0, -0.5]) {
                    cylinder(h = m4_tap_depth + 1, r = 1.65, $fn = 64);
                }
            }
        }
    }
}

// Plunger and metal disc (disc in base pocket; same transform as plunger)
module plunger_assembly() {
    translate([0, -linear_shaft_extension, 0]) {
        rotate([-90, 0, 0]) {
            rotate([0, 180, 0]) {
                children();
            }
        }
    }
}

color(tpu_color) {
    plunger_assembly() {
        plunger();
    }
}

color(steel_color) {
    plunger_assembly() {
        difference() {
            cylinder(h = plunger_disc_thickness, r = plunger_disc_radius, $fn = 64);
            translate([0, 0, -0.5]) {
                cylinder(h = plunger_disc_thickness + 1, r = 2.5, $fn = 64);
            }
        }
    }
}

// M4 countersunk hex socket screw
// Goes through plunger and disc into tapped hole
color(anodized_steel_color) {
    translate([0, -linear_shaft_extension, 0]) {
        rotate([-90, 0, 0]) {
            rotate([0, 180, 0]) {
                translate([0, 0, plunger_thickness]) {
                    rotate([180, 0, 0]) {
                        MetricHexSocketCountersunkHeadScrew(key="M4", l=m4_screw_length);
                    }
                }
            }
        }
    }
}

// Backstop
backstop_y = extrusion_length + plate_thickness * 2 - extrusion_groove_depth;
spring_stop_collar_y = 55;
shaft_coupling_y = 30;

color(petg_color) {
    rotate([90, 0, 0]) {
        translate([0, 0, -extrusion_length - plate_thickness*2 + extrusion_groove_depth]) {
                backstop();
        }
    }
}

// T-bushing in backstop groove
color(nylon_color) {
    translate([0, backstop_y - backstop_thickness - linear_shaft_groove_depth, 0]) {
        rotate([-90, 0, 0]) {
            t_bushing();
        }
    }
}

// Main compression spring
spring_collar_face_y = spring_stop_collar_y + stop_collar_thickness / 2;

color(steel_color) {
    translate([0, spring_collar_face_y, 0]) {
        rotate([-90, 0, 0]) {
            compression_spring(
                od = main_spring_od,
                wire_d = main_spring_wire_d,
                length = main_spring_length
            );
        }
    }
}

// Backstop stop collar
backstop_collar_y = backstop_y + backstop_thickness - stop_collar_thickness;

color(steel_color) {
    translate([0, backstop_collar_y, 0]) {
        rotate([-90, 0, 0]) {
            stop_collar();
        }
    }
}
color(anodized_steel_color) {
    translate([0, backstop_collar_y + stop_collar_thickness / 2, stop_collar_od / 2 + 0.5]) {
        rotate([180, 0, 0]) {
            m4_grub_screw();
        }
    }
}

// Spring stop collar
color(steel_color) {
    translate([0, spring_stop_collar_y, 0]) {
        rotate([-90, 0, 0]) {
            stop_collar();
        }
    }
}
color(anodized_steel_color) {
    translate([0, spring_stop_collar_y + stop_collar_thickness / 2, stop_collar_od / 2 + 0.5]) {
        rotate([180, 0, 0]) {
            m4_grub_screw();
        }
    }
}

// Shaft coupling on linear rod
color(steel_color) {
    translate([0, shaft_coupling_y, 0]) {
        rotate([-90, -45, 0]) {
            shaft_coupling();
        }
    }
}

// Grub screws in shaft coupling holes
color(anodized_steel_color) {
    translate([0, shaft_coupling_y, 0]) {
        rotate([-90, 135, 0]) {
            for (angle = [0, 90]) {
                rotate([0, 0, angle]) {
                    for (z_pos = [shaft_coupling_length / 4, 3 * shaft_coupling_length / 4]) {
                        translate([0, shaft_coupling_od / 2, z_pos]) {
                            translate([0, -1, 0]) {
                                rotate([90, 90, 0]) {
                                    m4_grub_screw(length = 3);
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

// M3 hex socket head cap screws
// Goes through backstop and into extrusion
color(steel_color) {
    backstop_z = -extrusion_length - plate_thickness*2 + extrusion_groove_depth;
    for (side = [-1, 1]) {
        translate([side * extrusion_center_offset, -backstop_z, 0]) {
            rotate([90, 0, 0]) {
                MetricHexSocketHeadCapScrew(key="M3", l=12);
            }
        }
    }
}

// Spring holder
color(petg_color) {
    translate([-extrusion_center_offset - extrusion_size / 2, plate_thickness + spring_holder_y_offset, -extrusion_size / 2]) {
        rotate([-90, 0, 0]) {
            spring_holder();
        }
    }
}

// M3 hex socket head cap screws
// Goes through spring holder and into extrusions
color(steel_color) {
    translate([-extrusion_center_offset - extrusion_size / 2, plate_thickness + spring_holder_y_offset, -extrusion_size / 2]) {
        rotate([-90, 0, 0]) {
            for (hole_x = [extrusion_size / 2, distance_between_outside_faces_of_extrusions - extrusion_size / 2]) {
                translate([hole_x, spring_holder_height, spring_holder_thickness / 2]) {
                    rotate([90, 0, 0]) {
                        translate([0, 0, spring_holder_m3_groove_depth()]) {
                            MetricHexSocketHeadCapScrew(key="M3", l=spring_holder_screw_length);
                        }
                    }
                }
            }
        }
    }
}

// Hammer (extrusions, joint, screws) — rotated down around fixed end of top extrusion
hammer_holder_bottom_z = hammer_holder_z_offset - hammer_holder_total_height / 2;
hammer_top_extrusion_z = hammer_holder_bottom_z - hammer_holder_total_height + extrusion_size / 2 - 2.5;
hammer_top_extrusion_start_y = plate_thickness + extrusion_length - hammer_holder_backstop_offset - hammer_top_extrusion_length;

translate([0, hammer_top_extrusion_start_y, hammer_top_extrusion_z - 5]) {
    rotate([4, 0, 0]) {
        translate([0, -hammer_top_extrusion_start_y, -hammer_top_extrusion_z]) {
            hammer_side_extrusion_y = plate_thickness + extrusion_length - hammer_holder_backstop_offset - hammer_top_extrusion_length - extrusion_size / 2;
            hammer_side_extrusion_start_z = hammer_top_extrusion_z + extrusion_size / 2 + hammer_top_extrusion_offset;

            // Hammer extrusions
            color(extrusion_color) {
                translate([0, plate_thickness + extrusion_length - hammer_holder_backstop_offset - hammer_top_extrusion_length, hammer_top_extrusion_z]) {
                    rotate([-90, 0, 0]) {
                        difference() {
                            makerbeam_xl_1515(hammer_top_extrusion_length);
                            // M5 screw clearance: hole through extrusion (at holder end)
                            translate([0, 0, hammer_top_extrusion_length - 5]) {
                                rotate([0, 90, 0]) {
                                    cylinder(d = hammer_top_extrusion_m5_through_hole_d, h = extrusion_size + 2, center = true, $fn = 32);
                                }
                            }
                            // Groove at the bottom of the extrusion to hold the spring
                            translate([0, extrusion_size / 2 + 5, hammer_top_extrusion_spring_holder_hole_offset]) {
                                rotate([90, 0, 0]) {
                                    cylinder(d = hammer_top_extrusion_spring_holder_hole_d, h = extrusion_size, center = true, $fn = 32);
                                }
                            }
                        }
                    }
                }
            }
            // Hammer spring (outside extrusion_color so steel_color applies)
            color(steel_color) {
                translate([0, plate_thickness + extrusion_length - hammer_holder_backstop_offset - hammer_top_extrusion_length, hammer_top_extrusion_z]) {
                    rotate([-90, 0, 0]) {
                        translate([0, extrusion_size / 2 + 5, hammer_top_extrusion_spring_holder_hole_offset]) {
                            rotate([90, 0, 0]) {
                                compression_spring(
                                    od = hammer_spring_od,
                                    wire_d = hammer_spring_wire_d,
                                    length = hammer_spring_length
                                );
                            }
                        }
                    }
                }
            }
            // Hammer perpendicular extrusion (angled cut on bottom)
            color(extrusion_color) {
                translate([0, hammer_side_extrusion_y, hammer_side_extrusion_start_z]) {
                    rotate([0, 180, 0]) {
                        difference() {
                            makerbeam_xl_1515(hammer_side_extrusion_length);
                            // End chamfer: rotated-cube wedge at one end
                            half = extrusion_size / 2;
                            translate([-half, -half, hammer_side_extrusion_short_length]) {
                                rotate([hammer_side_cut_angle, 0, 0]) {
                                    cube([extrusion_size, extrusion_size * 2, hammer_side_cut_rise]);
                                }
                            }
                        }
                    }
                }
            }

            // Pedal connector
            color(petg_color) {
                pedal_connector_placed(hammer_side_extrusion_y, hammer_side_extrusion_start_z) {
                    pedal_connector();
                }
            }

            // M6 bolt in pedal connector bolt cage
            color(steel_color) {
                pedal_connector_placed(hammer_side_extrusion_y, hammer_side_extrusion_start_z) {
                    translate([
                        pedal_connector_outer / 2,
                        pedal_connector_cavity_offset + pedal_connector_cavity_size + pedal_connector_m6_head_inset,
                        pedal_connector_bolt_cage_bottom_z + pedal_connector_bolt_cage_z / 2
                    ]) {
                        rotate([-90, 0, 0]) {
                            MetricHexSocketHeadCapScrew(key="M6", l=pedal_connector_m6_bolt_length);
                        }
                    }
                }
            }

            // M3 screw
            // Blind joint from side hammer extrusion into top hammer extrusion
            color(steel_color) {
                translate([0, hammer_side_extrusion_y - extrusion_size / 2, hammer_top_extrusion_z]) {
                    rotate([-90, 0, 0]) {
                        MetricHexSocketHeadCapScrew(key="M3", l=20);
                    }
                }
            }

            // Hammer joint (wraps top and side hammer extrusions at the blind joint)
            hammer_joint_tx = hammer_joint_width / 2;
            hammer_joint_ty = hammer_side_extrusion_y - extrusion_size + hammer_joint_right_offset - 0.5;
            hammer_joint_tz = hammer_top_extrusion_z - hammer_joint_bottom_offset - extrusion_size / 2;
            hammer_joint_side_hole_z = hammer_joint_bottom_offset + extrusion_size / 2;
            hammer_joint_top_edge_y = hammer_joint_width;
            hammer_joint_side_x = extrusion_size + hammer_joint_right_offset / 2;
            hammer_joint_top_z = hammer_joint_head_seat_z;

            color(petg_color) {
                translate([hammer_joint_tx, hammer_joint_ty, hammer_joint_tz]) {
                    rotate([0, 0, 90]) {
                        hammer_joint();
                    }
                }
            }

            // Hammer head
            hammer_head_placed(hammer_joint_tx, hammer_joint_ty, hammer_joint_tz + hammer_joint_top_z, hammer_joint_top_edge_y, extrusion_size, steel_color);

            // M3×12 countersunk screw through hammer head into hammer joint
            color(anodized_steel_color) {
                translate([
                    hammer_joint_tx - hammer_joint_top_edge_y / 2,
                    hammer_joint_ty + extrusion_size / 2,
                    hammer_joint_tz + hammer_joint_top_z + hammer_head_height
                ]) {
                    rotate([180, 0, 0]) {
                        MetricHexSocketCountersunkHeadScrew(key="M3", l=12);
                    }
                }
            }

            // M3×6 screws through the 4 side holes of the hammer joint
            color(steel_color) {
                translate([hammer_joint_tx, hammer_joint_ty + extrusion_size / 2, hammer_joint_tz + hammer_joint_side_hole_z]) {
                    rotate([180, 90, 0]) {
                        MetricHexSocketHeadCapScrew(key="M3", l=6);
                    }
                }
                translate([hammer_joint_tx - hammer_joint_top_edge_y, hammer_joint_ty + extrusion_size / 2, hammer_joint_tz + hammer_joint_side_hole_z]) {
                    rotate([180, -90, 0]) {
                        MetricHexSocketHeadCapScrew(key="M3", l=6);
                    }
                }
                translate([hammer_joint_tx, hammer_joint_ty + hammer_joint_side_x, hammer_joint_tz + hammer_joint_side_hole_z]) {
                    rotate([180, 90, 0]) {
                        MetricHexSocketHeadCapScrew(key="M3", l=6);
                    }
                }
                translate([hammer_joint_tx - hammer_joint_top_edge_y, hammer_joint_ty + hammer_joint_side_x, hammer_joint_tz + hammer_joint_side_hole_z]) {
                    rotate([180, -90, 0]) {
                        MetricHexSocketHeadCapScrew(key="M3", l=6);
                    }
                }
            }
        }
    }
}

// Places children at the pedal connector's origin on the bottom of the hammer side extrusion
module pedal_connector_placed(hammer_side_extrusion_y, hammer_side_extrusion_start_z) {
    translate([
        pedal_connector_outer / 2,
        hammer_side_extrusion_y + pedal_connector_outer / 2,
        hammer_side_extrusion_start_z - hammer_side_extrusion_short_length - pedal_connector_z_offset
    ]) {
        rotate([0, 0, 180]) {
            children();
        }
    }
}

// Places children in a hammer holder's own frame (as modelled in hammer_holder.scad).
// side = -1: screw-head side, side = 1: nut side.
module hammer_holder_placed(side) {
    holder_back_y = plate_thickness + extrusion_length - hammer_holder_backstop_offset;
    holder_origin_x = side * (extrusion_center_offset + hammer_holder_x_offset);
    holder_origin_y = holder_back_y - (side == 1 ? hammer_holder_depth : 0);

    rotate([90, 0, 180]) {
        translate([-holder_origin_x, -hammer_holder_z_offset, holder_origin_y]) {
            rotate([0, side == -1 ? 180 : 0, 0]) {
                children();
            }
        }
    }
}

// M5 pivot axis, in the hammer holder frame (Z along the bolt)
module hammer_holder_pivot() {
    translate([hammer_holder_wall + extrusion_size + hammer_holder_extra_width - hammer_holder_inner_corner_radius, hardware_holder_height / 2, hammer_holder_depth / 2]) {
        rotate([90, 0, 90]) {
            children();
        }
    }
}

// Mirrored sides
for (side = [-1, 1]) {
    extrusion_x = side * extrusion_center_offset;

    // Extrusion
    color(extrusion_color) {
        translate([extrusion_x, plate_thickness, 0]) {
            rotate([-90, 0, 0]) {
                makerbeam_xl_1515(extrusion_length);
            }
        }
    }

    // Baffle
    color(steel_color) {
        translate([extrusion_x, plate_thickness - baffle_thickness, 0]) {
            rotate([-90, 0, 0]) {
                baffle();
            }
        }
    }

    // M3 countersunk screws
    // Connects base plate to extrusion
    color(anodized_steel_color) {
        translate([extrusion_x, 0, 0]) {
            rotate([-90, 0, 0]) {
                MetricHexSocketCountersunkHeadScrew(key="M3", l=14);
            }
        }
    }

    // Hammer holders
    color(petg_color) {
        hammer_holder_placed(side) {
            hammer_holder(nut_side = (side == 1));
        }
    }

    // M3 hex socket head cap screws
    // Goes through hammer holder and into extrusion
    color(steel_color) {
        hammer_holder_placed(side) {
            // Hole 1: through face into extrusion (axis ±X depending on side)
            translate([0, hardware_holder_height + hammer_holder_wall + extrusion_size / 2, hammer_holder_depth / 2]) {
                rotate([0, 90, 0]) {
                    translate([0, 0, hammer_holder_m3_groove_depth]) {
                        MetricHexSocketHeadCapScrew(key="M3", l=8);
                    }
                }
            }
            // Hole 2: through bottom face into extrusion (axis ±Y depending on side)
            translate([hammer_holder_wall + extrusion_size / 2, hardware_holder_height, hammer_holder_depth / 2]) {
                rotate([-90, 0, 0]) {
                    translate([0, 0, hammer_holder_m3_groove_depth]) {
                        MetricHexSocketHeadCapScrew(key="M3", l=8);
                    }
                }
            }
        }
    }

    // M5 pivot: nut on the nut side, screw from the other side through the
    // hammer top extrusion and into the nut
    color(steel_color) {
        hammer_holder_placed(side) {
            hammer_holder_pivot() {
                if (side == 1) {
                    rotate([0, 0, 30]) {
                        translate([0, 0, 5]) {
                            MetricHexagonNut(key="M5");
                        }
                    }
                } else {
                    translate([0, 0, 6.5]) {
                        MetricHexSocketHeadCapScrew(key="M5", l=25);
                    }
                }
            }
        }
    }
}
