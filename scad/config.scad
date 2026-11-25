// Shared dimensions for the open-flyball-thruster.
//
// Anything used by more than one file (a printed part, a lib, or the
// thruster.scad assembly) lives here. Values only one part cares about stay in
// that part's file.
//
// Usage:
//   scad/<part>.scad      include <config.scad>
//   scad/lib/<lib>.scad   include <../config.scad>
//   thruster.scad         include <scad/config.scad>

// ---------------------------------------------------------------------------
// Base plate
plate_size = [77.5, 80];
plate_thickness = 8;

// ---------------------------------------------------------------------------
// Steel baffles (80×20×2 on the base)
baffle_width = 20;              // nominal width; positions the extrusions
baffle_profile_width = 19.9;    // width of the modelled baffle outline and the base recess
baffle_length = 80;
baffle_thickness = 2;
baffle_partial_arc_radius = 20;
baffle_slot_width = 6.5;
baffle_slot_length = 15;
baffle_edge_offset = 2;

// ---------------------------------------------------------------------------
// 1515 aluminium extrusions
extrusion_size = 15;
extrusion_length = 115;                 // main profile pieces (×2)
extrusion_groove_depth = 1;             // how far the extrusions sit into the backstop
hammer_top_extrusion_length = 65;
hammer_side_extrusion_length = 135;     // long side of the angled cut
hammer_side_extrusion_short_length = 125; // short side of the angled cut (pedal connector)
hammer_side_cut_rise = hammer_side_extrusion_length - hammer_side_extrusion_short_length;
hammer_side_cut_angle = atan(hammer_side_cut_rise / extrusion_size);

extrusion_center_offset = plate_size[0] / 2 - baffle_width / 2;
distance_between_outside_faces_of_extrusions = 2 * extrusion_center_offset + extrusion_size;

// ---------------------------------------------------------------------------
// Fasteners
m3_hole_diameter = 3.2;
m3_hole_radius = m3_hole_diameter / 2;
m3_groove_diameter = 6.5;   // counterbore for M3 button / socket heads

// ---------------------------------------------------------------------------
// Linear rod, bushings, collars, springs
t_bushing_id = 8;
t_bushing_flange_od = 16;
t_bushing_flange_thickness = 3;
t_bushing_body_od = 10;
t_bushing_body_height = 5;

// Extra radius (per side, mm) added to the bushing bores in the base and
// backstop and to the flange recess in the backstop. 0 = exact size, which
// relies on PETG printing holes slightly undersize for a press fit. Increase
// (e.g. 0.05–0.15) if the bushings are too tight to push in on your printer.
bushing_fit_clearance = 0;

linear_shaft_hole_radius = t_bushing_body_od / 2 + bushing_fit_clearance;     // bore for the T-bushing body (base + backstop)
linear_shaft_groove_radius = t_bushing_flange_od / 2 + bushing_fit_clearance; // T-bushing flange recess (backstop)
linear_shaft_groove_depth = 2;      // T-bushing flange recess depth in the backstop

stop_collar_id = 8;
stop_collar_od = 14;
stop_collar_thickness = 7;

shaft_coupling_id = 8;
shaft_coupling_od = 14;
shaft_coupling_length = 22;

m4_tap_radius = 1.65;

main_spring_od = 12;
main_spring_wire_d = 1.2;
main_spring_length = 70;

hammer_spring_od = 8;
hammer_spring_wire_d = 0.9;
hammer_spring_length = 10;

// ---------------------------------------------------------------------------
// Backstop
backstop_thickness = 8;

// ---------------------------------------------------------------------------
// Plunger
plunger_thickness = 10;

// ---------------------------------------------------------------------------
// Hammer holders (pivot blocks on the main extrusions)
hammer_holder_wall = 6;
hammer_holder_depth = 12;
hammer_holder_inner_corner_radius = 5;
hammer_holder_m3_groove_depth = 1;
hardware_holder_height = 14;
hammer_extrusion_play = 1;          // side clearance for the hammer between the main extrusions
hammer_holder_extra_width = extrusion_center_offset - extrusion_size - hammer_holder_wall - hammer_extrusion_play / 2;

// ---------------------------------------------------------------------------
// Hammer joint + hammer head
hammer_joint_wall = 3;
hammer_joint_bottom_offset = 6;
hammer_joint_right_offset = 8;
hammer_top_extrusion_offset = 3;
hammer_head_height = 6;
hammer_head_height_offset = 4.5;    // how deep the hammer head sits in the joint's top pocket
hammer_joint_width = extrusion_size + 2 * hammer_joint_wall;
// Z of the floor of the hammer head pocket (where the hammer head sits)
hammer_joint_head_seat_z = hammer_joint_bottom_offset + extrusion_size + hammer_top_extrusion_offset + hammer_joint_wall;

// ---------------------------------------------------------------------------
// Spring holder (holds the hammer spring down)
spring_holder_height = 34;
spring_holder_thickness = 20;
spring_holder_screw_length = 30;
spring_holder_screw_extra_for_nut = 4;  // how far the M3 screw reaches past the part into the square nut
// Depth of the M3 head counterbore for a given spring holder height
function spring_holder_m3_groove_depth(height = spring_holder_height) =
    max(0, height - spring_holder_screw_length + spring_holder_screw_extra_for_nut);

// ---------------------------------------------------------------------------
// Pedal connector (slides over the bottom of the hammer side extrusion)
pedal_connector_height = 20;
pedal_connector_wall = 2;
pedal_connector_extrusion_tolerance = 0.1;
pedal_connector_outer = extrusion_size + 2 * pedal_connector_wall;
pedal_connector_cavity_size = extrusion_size + 2 * pedal_connector_extrusion_tolerance;
pedal_connector_cavity_offset = (pedal_connector_outer - pedal_connector_cavity_size) / 2;
pedal_connector_total_height = pedal_connector_height + hammer_side_cut_rise;
pedal_connector_bolt_cage_bottom_z = (hammer_side_cut_rise / extrusion_size) * pedal_connector_outer;
pedal_connector_bolt_cage_z = pedal_connector_total_height - pedal_connector_bolt_cage_bottom_z;
