module servo_mockup(
  servo_width,
  servo_length,
  servo_height,
  frame_length,
  frame_thickness,
  frame_v_offset,
  mounting_hole_diameter,
  mounting_hole_center_x_offset,
  mounting_hole_center_y_offset,
  mounting_hole_slot,
  axle_diameter,
  axle_height,
  axle_is_round=true,
  axle_screw_diameter,
  turret_diameter,
  turret_x_margin,
  turret_y_margin,
  turret_height,
  axle_color="Silver",
  body_color="Black",
  frame_color="Black",
  turret_color="Gray",
  centered=false,
) {

  module __servo_mockup() {
    // Mock-up of the servo itself
    union() {
      // gear box
      translate([0, (frame_length - servo_length) / 2, 0]) {
        union() {
          color(body_color) {
            cube([servo_width, servo_length, servo_height]);
          }
          translate([turret_x_margin + turret_diameter / 2,
                     turret_y_margin + turret_diameter / 2,
                     servo_height]) {
            color(turret_color) {
              cylinder(r=(turret_diameter / 2), h=turret_height);
            }
            translate([0, 0, turret_height]) {
              difference() {
                color(axle_color) {
                  servo_axle(axle_diameter, axle_height, axle_is_round);
                } 
		cylinder(r=(axle_hole_diameter / 2), h=axle_height);
              }
            }
          }
        }
      }
      // support frame
      translate([0, 0, frame_v_offset]) {
        difference() {
          color(frame_color) {
            cube([servo_width, frame_length, frame_thickness]);
          }
          for (y = [0, 1]) {
            for (x = [0, 1]) {
              translate([x * servo_width + (-2 * x + 1) * mounting_hole_center_x_offset,
                         y * frame_length + (-2 * y + 1) * mounting_hole_center_y_offset,
                         0]) {
                cylinder(r=(mounting_hole_diameter / 2), h=(3 * frame_thickness), center=true);
              }
            }
          }
        }
      }
    }
  }
  if (centered) {
    translate([-(servo_width / 2),
               -((frame_length - servo_length) / 2 + turret_y_margin + turret_diameter / 2),
               -servo_height]) {
      __servo_mockup();
    }
  } else {
    __servo_mockup();
  } 
}


module servo_axle(axle_diameter,  // or diagonal
                  axle_height, 
                  axle_is_round=true) {  // overshoot 
  if (axle_is_round) {
    cylinder(r=(axle_diameter / 2), h=axle_height);
  } else {
    translate([0, 0, axle_height / 2]) {
      cube([axle_diameter * .707,
            axle_diameter * .707,
            axle_height],
           center=true);
    }
  }
}
