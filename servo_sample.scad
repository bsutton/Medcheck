$fn=60;

use <servo_mockup.scad>;

//
// List of servos I have.
//
// include <futaba.scad> will make these variables available

//
// MG90-S: metal-gear microservo
//
mg90s__servo_width = 12.5;
mg90s__servo_length = 22.9;
mg90s__servo_height = 22.9;
mg90s__frame_length = 32.2;
mg90s__frame_thickness = 2.45;
mg90s__frame_v_offset = 18.5;
mg90s__mounting_hole_diameter = 2;
mg90s__mounting_hole_slot = 1;
mg90s__mounting_hole_center_x_offset = mg90s__servo_width/2;
mg90s__mounting_hole_center_y_offset = mg90s__mounting_hole_slot + mg90s__mounting_hole_diameter / 2 ;
mg90s__axle_diameter = 4.82;
mg90s__axle_height = 3.9;
mg90s__axle_screw_diameter = 2;
mg90s__turret_diameter = 11.7;
mg90s__turret_x_margin = (mg90s__servo_width - mg90s__turret_diameter) / 2;
mg90s__turret_y_margin = mg90s__servo_length - mg90s__turret_diameter;
mg90s__turret_height = 5.2;

module mg90s(centered=true) {
  servo_mockup(
    servo_width = mg90s__servo_width,
    servo_length = mg90s__servo_length,
    servo_height = mg90s__servo_height,
    frame_length = mg90s__frame_length,
    frame_thickness = mg90s__frame_thickness,
    frame_v_offset = mg90s__frame_v_offset,
    mounting_hole_diameter = mg90s__mounting_hole_diameter,
    mounting_hole_center_x_offset = mg90s__mounting_hole_center_x_offset,
    mounting_hole_center_y_offset = mg90s__mounting_hole_center_y_offset,
    mounting_hole_slot = mg90s__mounting_hole_slot,
    axle_diameter = mg90s__axle_diameter,
    axle_height = mg90s__axle_height,
    axle_is_round = true,
    turret_diameter = mg90s__turret_diameter,
    turret_x_margin = mg90s__turret_x_margin,
    turret_y_margin = mg90s__turret_y_margin,
    turret_height = mg90s__turret_height,
    centered=centered);
}

mg90s();