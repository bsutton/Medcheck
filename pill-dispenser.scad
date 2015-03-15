include <raspberry-pie-mount.scad>
include <raspberry-pie-model.scad>
/**
 * Terms
 * cartridge - A cylindrical segmented container designed to hold pills.
 * 					The catridge is designed to be directly connected to a
 *					motor which rotates the cartridge within the enclosing
 *					cansiter.
 * 					The cartridge has draw_depth segmented wedges. 14 of the wedges can 
 * 					hold a number of pills. The draw_depth segment is used to aid
 * 					alignment when inserting the cansiter into the pill collector.
 * canister - pill holding unit consisting of the cansister enclosure and 
 * 				a cartridge that is inserted into the enclosure.
 * 				The cartridge can rotate within the canister.
 */

//$fn=100;

CLOCKWISE=1;
ANTICLOCKWISE=-1;
FILL=1;
NOFILL=0;

// diameter of the outer body cylinder
gap=0.5;
overlap = 1; // used to overlap to object that must be joined.
wall_width=3;
body_radius = 80;
catridge_lid_radius = body_radius-wall_width-gap;
catridge_radius = catridge_lid_radius-wall_width*2-gap;

// the hieght of the bottom of the cartridge
catride_base_height=160;

pie_mount_height=80;
pie_mount_width = 50;

spiral_width = 35;
spiral_height = 120;

body_height=160;

collector_end_radius=37;
collector_centre_width=body_radius/2;



prong_height=10;
prong_radius = 4;

hub_radius = (catridge_radius+2)/3;

// the .25 is so the raised hub is slight smaller than the lid whole
raised_hub_radius = hub_radius-4.25;

canister_height=43;
catridge_height=38;

motor_shaft_radius=2;

bob();

module bob()
{
	draw_depth=30;
	draw_width=60;
	
	translate([-10,0,draw_depth+wall_width])
	rotate([0,180,0])
	difference()
	{
	/*
	 * outer draw.
	 */ 
		
		difference()
		{
			translate([0,-draw_width/2,0])
			cube([85,draw_width,draw_depth]);
			//overlap*2
			translate([0,0,-overlap])
			difference	()
			{											 
				cylinder(r=100,h=draw_depth+overlap*2);
				cylinder(r=75,h=draw_depth);
			}
			translate([0,0,-overlap])
			cylinder(r=hub_radius,h=draw_depth+overlap*2);
		}
	
	/*
	 * Inner draw.
	 */
		
			difference()
		{
			translate([0+wall_width,-draw_width/2+wall_width,-overlap])
			cube([85-wall_width*2,draw_width-wall_width*2,draw_depth+overlap-wall_width]);
			//overlap*2
			translate([0,0,-overlap])
			difference	()
			{											 
				cylinder(r=87,h=draw_depth+overlap*2);
				cylinder(r=75-wall_width,h=draw_depth);
			}
			translate([0,0,-overlap])
			cylinder(r=hub_radius+wall_width,h=draw_depth+overlap*2);
		}
	}
}

//translate([100,400,0])
pill_tray();

body();


module pill_tray()
{

	translate([0,0,130])
	rotate([180,0,0])
	fork_connector();

	translate([0,0,250])
	rotate([180,0,0])
	cartridge();

	translate([0,0,200])
	cartridge_hub_cap();

	translate([0,0,catride_base_height+25])
	rotate([180,0,-79])
	catridge_lid();
}



module body()
{
	%shell(1);
	
	// place the collelctor carving a whole for the end of the pill chute.
	difference()
	{
		translate([body_radius, 20,collector_end_radius])
		collector();
		place_chute(FILL);
	}

	// place the pill chute carving it to the sape of the collector
	difference()
	{
		place_chute(NOFILL);
		carve_collector();
	}

	// place the dump chute carving it to the sape of the collector
//	difference()
//	{
//		pill_chute(NOFILL);
//	}
//

	// place the dump bridge
	translate([0,-spiral_width-10,spiral_height-13])
	dump_bridge(-32);

	// place the rapberry pie mount.
	pie();

	// place the motor
	motor();


}

module place_chute(fill)
{
	translate([0,0,30])
	rotate([0,0,20])
	pill_chute(ANTICLOCKWISE, fill);


}


/**
 * Draws a spiral. The top spiral (stair) is aligned with the x-axis
 *  with the spiral wrapping around the z-axis towards the y-axis if 
 *  the spiral is clockwise or the -ve y-axis if the spiral is counter-clockwise.
 * The spiral is drawn as a series of steps. If there are enough stairs
 * then the spiral looks smooth.
 *
 * height - the hight of the spiral
 * steps - the more steps the finer the spiral and the longer it takes to draw.
 * width - the width of the spiral (the stairs)
 * thickness - the thickness of the spiral (under the stair tread if you like).
 * rotation - the degrees the spiral turns from top to the bottom.
 * internal radius - the radius from the z-axis to the inner edge of the
 * 		spiral (i.e. the clear space between the z-axis and the edge of the spiral.
 * 		Use zero for a spiral that goes to the centre of the z-axis.
 * clockwise - direction of the spiral 1 for clockwise -1 for anticlockwise
 */

module spiral_tube(height, steps, width, thickness, rotation, internal_radius, clockwise)
{	
	step_height = height/steps;
	step_rotation = rotation/steps ;
	
	translate([0,0,height])
	{
		difference()
		{
			for ( z = [1:steps]) 
			{
				rotate(z*step_rotation*-clockwise) 
				translate([0,-internal_radius,-z*step_height])
				
				difference()
				{
					cylinder(r=width/2,h=step_height+.3);
					translate([0,0,-overlap])
					cylinder(r=width/2-thickness, h=step_height+overlap*2);
				}
			}
		}
	}

}

module pill_chute(clockwise, fill)
{
	bottom = 25;
	height = 60;
	steps=40;		// increase to get a smoother spiral
	rotation=60; // degrees of rotation for spiral

	if (fill == NOFILL)
		spiral_tube(height, steps, spiral_width, 1, rotation
			, body_radius-spiral_width/2-overlap,clockwise);
	else
		spiral_tube(height, steps, spiral_width, spiral_width/2, rotation
			, body_radius-spiral_width/2-overlap,clockwise);
	
	// domed mouth of pill collector
	translate([0, -(body_radius-spiral_width/2)+1, height+7-overlap])
	difference()
	{
		sphere(r=spiral_width/2+2);
		if (fill == NOFILL)
		{
			sphere(r=spiral_width/2-wall_width+1);
		}
		// clip the sphere to:

		//  open it to the drop bridge 
		rotate([0,-75,0])
		cylinder(r=spiral_width,h=spiral_width+overlap);

		//  open it to the spiral tube
		translate([0,0,-7])
		rotate([0,-180,0])
		cylinder(r=spiral_width,h=spiral_width+overlap);

	}
}


module shell(hidebase)
{
	// outer body
	difference()
	{
		cylinder(r=body_radius, h=body_height);
		translate([0,0,wall_width+1])
		cylinder(r=body_radius-wall_width, h=body_height);

		if (hidebase)
		{
			translate([0,0,-1])
			cylinder(r=body_radius-wall_width, h=body_height);
		}
			
		carve_collector();
	}
}


/**
  * See saw mechanism to dump tablets that were not dispensed
  * on time.
  */


module dump_bridge(angle)
{	
	width = spiral_width;
	length = 40;
	axle_radius = 1.5;

	color("grey")
	
	rotate([angle,0,-90])
	difference()
	{
		intersection()
		{
			union()
			translate([0,-length/2,0])
			{
				cube([width,length,wall_width]);
			
				// centre pivot for the bridge.
				translate([0,length/2,-1.5])
				rotate([0,90,0])
				difference()
				{
					cylinder(r=3, h=width);
					translate([0,0,-gap])
					cylinder(r=axle_radius, h=width+gap*2);
				}
			}
			// round the outer edge of the bridge to fit the external wall.
			translate([-body_radius+width,0,-5])
			cylinder(r=body_radius-wall_width-gap, h=15);
		}
		// round the inner edge of the bridge.
		translate([-(body_radius-spiral_width)/2-22,0,-11])
		cylinder(r=body_radius-spiral_width+gap*3, h=15);
	}
}



/**
 * Draws a spiral. The top spiral (stair) is aligned with the x-axis
 *  with the spiral wrapping around the z-axis towards the y-axis if 
 *  the spiral is clockwise or the -ve y-axis if the spiral is counter-clockwise.
 * The spiral is drawn as a series of steps. If there are enough stairs
 * then the spiral looks smooth.
 *
 * height - the hight of the spiral
 * steps - the more steps the finer the spiral and the longer it takes to draw.
 * width - the width of the spiral (the stairs)
 * thickness - the thickness of the spiral (under the stair tread if you like).
 * rotation - the degrees the spiral turns from top to the bottom.
 * internal radius - the radius from the z-axis to the inner edge of the
 * 		spiral (i.e. the clear space between the z-axis and the edge of the spiral.
 * 		Use zero for a spiral that goes to the centre of the z-axis.
 * clockwise - direction of the spiral 1 for clockwise -1 for anticlockwise
 */

module spiral(height, steps, width, thickness, rotation, internal_radius, clockwise)
{	
	step_height = height/steps;
	step_rotation = rotation/steps ;
	
	translate([0,0,height])
	{
		difference()
		{
			for ( z = [0:steps-1]) 
			{
				rotate(z*step_rotation*-clockwise) 
				translate([0,0,-z*step_height]) 
				cube(size = [width+internal_radius,thickness,1], center = false);
			}
		
			// cut out the inner radius
			translate([0,0,-height])
			cylinder(r=internal_radius,h=height+2);
		}
	}

}

module cartridge()
{
		// Outer skin800

	difference()
	{
		translate([0,0,1])
		cylinder(r=catridge_radius, h=catridge_height-3);
		translate([0,0,wall_width])
		cylinder(r=catridge_radius-2, h=catridge_height);
		translate([0,0,-20])
		cylinder(r=hub_radius-2, h=catridge_height+wall_width+100);
		translate([0,0,0])
		rotate([0,0,1.5])
			wedge(catridge_height+wall_width, catridge_radius-wall_width, 360/14 - 3);

	

	}

	// add a slight campher on the outer edge so it meshes with the
	// small tags on the lid. The tags are designed to hold the 
	// cartridge in place when it is turned up side down.
	translate([0,0,-98])
	difference()
	{
			translate([0,0,-1])
			cylinder(r=0, r2=catridge_lid_radius-wall_width*2, h=100);
			translate([0,0,-3])
			cylinder(r=catridge_lid_radius-wall_width-4, h=100);
		translate([0,0,90])
		rotate([0,0,1.5])
			wedge(catridge_height+wall_width, catridge_radius-wall_width, 360/14 - 3);
		translate([0,0,-20])
		cylinder(r=hub_radius-2, h=catridge_height+wall_width+100);	

	}

//TODO: segments only just meet hub.

	// create the pill segments.
	difference()
	{
		for ( rot = [0 :  14])
		{
			rotate([0,0,(22 + 2) * rot])
			cube([catridge_radius-1, wall_width, catridge_height]);
		}
		
		// remove the segments from the innner hub
		translate([0,0,-10])
		cylinder(r=hub_radius, h=catridge_height*2);	
	}

	// inner hub
	difference()
	{
		cylinder(r=hub_radius, h=catridge_height-2);

		
		translate([0,0,-10])
		cylinder(r=hub_radius-2, h=catridge_height+10);	
	}


	// add little tags to make it easy to extract the cartridge
	rotate([0,0,90])
	translate([hub_radius,0,-1])
	cylinder(r=hub_radius/3, h=wall_width);

	rotate([0,0,270])
	translate([hub_radius,0,-1])
	cylinder(r=hub_radius/3, h=wall_width);
}


/**
 * hub cap is glued to the centre of the cartridge.
 * The motor fork connector engages the hub cab directly.
 */
module cartridge_hub_cap()
{
	difference()
	{
		union()
		{
			// central hub
			translate([0,0,0])
			difference()
			{
				cylinder(r=hub_radius-gap/2, h=wall_width);
				cylinder(r=hub_radius-2, h=wall_width-2);	
			}
		
			difference()
			{
				// central raised hub - used to engage with lid
				translate([0,0,0])
				cylinder(r=raised_hub_radius, h=wall_width*2);
			}
		}
		// motor connections - D shape
		translate([0,0,-wall_width*3])
		difference()
		{
			cylinder(r=motor_shaft_radius, h=catridge_height+wall_width*8);
			translate([motor_shaft_radius/2, -motor_shaft_radius,5 ])			
			cube([motor_shaft_radius*2,motor_shaft_radius*2, motor_shaft_radius*3]);
		}
		

		// prongs wholes for fork connector
		translate([raised_hub_radius/2, 0,-4])
		cylinder(r=prong_radius, h=prong_height);
	
		translate([-raised_hub_radius/2, 0,-4])
		cylinder(r=prong_radius, h=prong_height);

	}
}

/**
 * The fork connector is designed to solve two possible problems
 * with motor connection to the hub.
 *
 * 1) the d-connector may wear over time due to the weak plastic.
 * 2) The fork connector can be powered to raise up and down
 *   this would allow us to add a second canister layer to double
 *   the number of dispensing actions.
 * 3) The fork prongs may make it easier to insert the cartridge.
 */
module fork_connector()
{


	difference()
	{
		union()
		{
			// base plate
			cylinder(r=raised_hub_radius, wall_width);
			
			// prongs
			translate([raised_hub_radius/2, 0,-prong_height])
			cylinder(r=prong_radius-gap/2, h=prong_height);
		
			translate([-raised_hub_radius/2, 0,-prong_height])
			cylinder(r=prong_radius-gap/2, h=prong_height);
		}

		// motor connections - D shape
		translate([0,0,-wall_width*3])
		difference()
		{
			cylinder(r=motor_shaft_radius, h=catridge_height+wall_width*8);
			translate([motor_shaft_radius/2, -motor_shaft_radius, 0])
			cube([motor_shaft_radius*2,motor_shaft_radius*2, motor_shaft_radius*2]);
		}
	}

}

module catridge_lid()
{
	difference()
	{
		cylinder(r=catridge_lid_radius, h=canister_height);
		translate([0,0,-wall_width])
		{
			// hollow out the main cylinder
			cylinder(r=catridge_lid_radius-wall_width*2, h=canister_height);

			//rotate(-7)
			difference()
			{
			// First wedge for pill cavity is a complete cut through
			wedge(canister_height+10, catridge_lid_radius-wall_width-2, 360/14 - 2);
			cylinder(r=catridge_lid_radius/3, h=canister_height+10);
			}
		}

	// whole to engage the central hub of the catridge.
	// central raised hob - used to engage with lid
	translate([0,0,canister_height-4])
	cylinder(r=hub_radius-4, h=wall_width*3+overlap);
		
	}

	// Add a segmented rim around the inside edge which
	// snaps beind the cartridge to hold the cartridge in place.
	difference()
	{
		cylinder(r=catridge_lid_radius, h=wall_width*4);
		translate([0,0,-3])
		cylinder(r=catridge_lid_radius-wall_width*4, h=wall_width*6);

		// we just want three lips left so lets cut some wedges out.
		translate([0,0,-1])
		wedge(canister_height+10, catridge_lid_radius-wall_width-2, 100);
		translate([0,0,-1])
		rotate([0,0,120])
		wedge(canister_height+10, catridge_lid_radius-wall_width-2, 100);
		translate([0,0,-1])
		rotate([0,0,240])
		wedge(canister_height+10, catridge_lid_radius-wall_width-2, 100);
		
		// campher the edges to 45 degrees - so we can 3d print.
		translate([0,0,-canister_height*2-2])
		cylinder(r=0, r2=catridge_lid_radius-wall_width*2, h=100);
		translate([0,0,5])
		cylinder(r=catridge_lid_radius-wall_width-2, h=wall_width*6);
	}
}


/**
 * The outlet from where pills are taken.
 */
module collector()
{
	difference()
	{
		union()
		{
			rotate([90,0,0])
			cylinder(r=collector_end_radius,h=collector_centre_width);
			translate([0,0,0])
			sphere(r=collector_end_radius);
			translate([0,-collector_centre_width,0])
			sphere(r=collector_end_radius);
		}

		internal_carve_collector();
	
		// opening for the removal of pills
		translate([0,-(collector_end_radius+collector_centre_width+overlap), 0])
		cube([collector_end_radius
			, collector_end_radius*2+collector_centre_width+2*overlap
			, collector_end_radius]);

		

////		// carve out the pill chute
//			translate([0,0,30])
//			rotate([0,0,20])
//			spiral_tube(height, 100, spiral_width, 3, 60, body_radius-spiral_width/2-overlap,-1);
		

	}
}

module carve_collector()
{
	translate([body_radius, 20,collector_end_radius])
	internal_carve_collector();
}

// hollow the collector out
module internal_carve_collector()
{
	rotate([90,0,0])
	cylinder(r=collector_end_radius-wall_width,h=collector_centre_width);
	translate([0,0,0])
	sphere(r=collector_end_radius-wall_width);
	translate([0,-collector_centre_width,0])
	sphere(r=collector_end_radius-wall_width);

}


module pie()
{
	translate([-body_radius+50, body_radius-10,95])
	rotate([90,90,0])
	{
		pie_brackets();
		pie_mount(0);
		translate([0,0,5])
		rpi();
	}
}

module pie_brackets()
{

}







/**
 *  Model of motor
 * http://www.ebay.com.au/itm/12V-DC-60RPM-Powerful-High-Torque-Gear-Box-Motor-New-/260793907276?pt=AU_B_I_Electrical_Test_Equipment&hash=item3cb887384c
 *
 * Body
 * Dia: 25mm
 * Length: 72mm
 * Shaft 
 *  Dia: 4mm
 *  Length: 20 mm (guess)
**/

module motor()
{
	color("grey")
	{
	// body
	cylinder(r=12.5, h=72);

	// shaft
	translate([0,0,72])
	cylinder(r=2, h=20);

	// collar
	translate([0,0,72])
	cylinder(r=4, h=4);
	}
	
}


module wedge_180(h, r, d)
{
	rotate(d) difference()
	{
		rotate(180-d) difference()
		{
			cylinder(h = h, r = r);
			translate([-(r+1), 0, -1]) cube([r*2+2, r+1, h+2]);
		}
		translate([-(r+1), 0, -1]) cube([r*2+2, r+1, h+2]);
	}
}

module wedge(h, r, d)
{
	if(d <= 180)
		wedge_180(h, r, d);
	else
		rotate(d) difference()
		{
			cylinder(h = h, r = r);
			translate([0, 0, -1]) wedge_180(h+2, r+1, 360-d);
		}
}


