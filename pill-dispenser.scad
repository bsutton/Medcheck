include <raspberry-pie-mount.scad>
include <raspberry-pie-model.scad>
include <spiral.scad>
include <servo_mockup.scad>

/**
 * Terms
 * cartridge - A cylindrical segmented container designed to hold pills.
 * 					The cartridge is designed to be directly connected to a
 *					motor which rotates the cartridge within the enclosing
 *					cansiter.
 * 					The cartridge has drawer_depth segmented wedges. 14 of the wedges can 
 * 					hold a number of pills. The drawer_depth segment is used to aid
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

// controls what we want to draw by commenting out the lines
// of those entities that you want drawn.
// By default we draw everything.
show_shell = false;
show_shell_base = false;
show_inner_shell = true;
show_cartridge = true;
show_cartridge_lid = true;
show_cartridge_hub = true;
show_motor_connector = false;
show_motor = false;
show_pie = false;
show_pie_mount = false;
show_drawer = true;
show_collector = true;
show_dump_bridge = true;
show_pill_chute = true;
show_dump_chute = true;
show_dump_servo=true;


// diameter of the outer body cylinder
gap=0.5;
overlap = 1; // used to overlap to object that must be joined.
wall_width=3;
outer_shell_radius = 80;
outer_shell_height=160;

pie_mount_height=80;
pie_mount_width = 50;

spiral_width = 35;
spiral_height = 120;

dump_bridge_height = spiral_height-13;



cartridge_lid_radius = outer_shell_radius-wall_width-gap;
cartridge_radius = cartridge_lid_radius-wall_width*2-gap;

// the hieght of the bottom of the cartridge
cartridge_lid_base=spiral_height;

inner_shell_radius=outer_shell_radius-spiral_width+gap*2;
inner_shell_height=cartridge_lid_base-gap;


collector_end_radius=37;
collector_centre_width=outer_shell_radius/2;

prong_height=10;
prong_radius = 4;

hub_radius = (cartridge_radius+2)/3;

// the .25 is so the raised hub is slight smaller than the lid whole
raised_hub_radius = hub_radius-4.25;

canister_height=43;
cartridge_height=38;

// The height of the motor from the base of the shell

motor_height=72;
motor_radius = 12.5;
motor_collar_height =4;
motor_collar_radius =4;
motor_shaft_height = 20;
motor_shaft_radius=2;	
motor_base = dump_bridge_height-motor_height+10;

// metrics for dump bridge servo

dump___servo_width = 12.5;
dump___servo_length = 22.9;
dump___servo_height = 22.9;
dump___frame_length = 32.2;
dump___frame_thickness = 2.45;
dump___frame_v_offset = 18.5;
dump___mounting_hole_diameter = 2;
dump___mounting_hole_slot = 1;
dump___mounting_hole_center_x_offset = dump___servo_width/2;
dump___mounting_hole_center_y_offset = dump___mounting_hole_slot + dump___mounting_hole_diameter / 2 ;
dump___axle_diameter = 4.82;
dump___axle_height = 3.9;
dump___axle_screw_diameter = 2;
dump___turret_diameter = 11.7;
dump___turret_x_margin = (dump___servo_width - dump___turret_diameter) / 2;
dump___turret_y_margin = dump___servo_length - dump___turret_diameter;
dump___turret_height = 5.2;


function saw(t) = 1 - 2*abs(t-0.5);

whole_unit();


module whole_unit()
{


// diameter of the outer body cylinder
echo("gap=0.5");
echo("overlap = 1"); 
echo("wall_width=3");
echo("outer_shell_radius = 80");
echo("outer_shell_height=160");

echo("pie_mount_height=80");
echo("pie_mount_width = 50");

echo("spiral_width = 35");
echo("spiral_height = 120");

echo("dump_bridge_height = ", spiral_height-13);



echo("cartridge_lid_radius = ",outer_shell_radius-wall_width-gap);
echo("cartridge_radius = ", cartridge_lid_radius-wall_width*2-gap);

// the hieght of the bottom of the cartridge
echo("cartridge_lid_base=",spiral_height);

echo("inner_shell_radius=",outer_shell_radius-spiral_width+gap*2);
echo("inner_shell_height=",cartridge_lid_base-gap);


echo("collector_end_radius=37");
echo("collector_centre_width=",outer_shell_radius/2);

echo("prong_height=10");
echo("prong_radius = 4");

echo("hub_radius = ",(cartridge_radius+2)/3);

// the .25 is so the raised hub is slight smaller than the lid whole
echo("raised_hub_radius = ",hub_radius-4.25);

echo("canister_height=43");
echo("cartridge_height=38");

// The height of the motor from the base of the shell

echo("motor_height=72");
echo("motor_radius = 12.5");
echo("motor_collar_height =4");
echo("motor_collar_radius =4");
echo("motor_shaft_height = 20");
echo("motor_shaft_radius=2");	
echo("motor_base = ",dump_bridge_height-motor_height+10);
	
	body();
	
	//translate([100,400,0])
	//rotate([0,0,30])
	cartridge_assembly();

	if (show_drawer)
		translate([saw($t)*-50,0,0])
		drawer();

}

/**
 * the cartridge lid and the cartridge along with fork motor connector 
 * and the hub cap for the cartridge.
 */
module cartridge_assembly()
{

	if (show_motor_connector)
		translate([0,0,dump_bridge_height+25])
		rotate([180,0,saw($t)*180])
		motor_connector();

	if (show_cartridge)
		translate([0,0,250])
		rotate([180,0,saw($t)*180])
		cartridge();

	if (show_cartridge_hub)
		rotate([0,0,saw($t)*180])
		translate([0,0,200])
		cartridge_hub_cap();

	if (show_cartridge_lid)
		translate([0,0,cartridge_lid_base])
		cartridge_lid();
}



module body()
{
	if (show_shell)
		shell();
	if (show_inner_shell)
		inner_shell();
	
	// place the collector carving a whole for the end of the pill chute.
	
	if (show_collector)
		difference()
		{
			translate([outer_shell_radius, 20,collector_end_radius])
			collector();
			place_chute(FILL);
		}

	// place the pill chute carving it to the sape of the collector
	if (show_pill_chute)
		difference()
		{
			place_chute(NOFILL);
			carve_collector();
		}

	// place the dump chute carving it to the sape of the collector
	if (show_dump_chute)
	{
		rotate([0,0,-20])
		translate([0,0,40])
		dump_chute(CLOCKWISE, NOFILL);
	}

	// place the dump bridge
	if (show_dump_bridge)
	{
		translate([0,-spiral_width-10,dump_bridge_height])
		dump_bridge(0);
	}

	if (show_dump_servo)
	{
		translate([0,-inner_shell_radius,dump_bridge_height])
		rotate([90, 0, -0])
		dump_chute_servo();
	}

	// place the rapberry pie mount.
	if (show_pie)
		pie();

	// place the motor
	if (show_motor)
		translate([0,0,motor_base])
		motor();


}

module dump_chute(clockwise, fill)
{
	bottom = 25;
	height = 50;
	steps=40;		// increase to get a smoother spiral
	rotation=60; // degrees of rotation for spiral

	if (fill == NOFILL)
		spiral_tube(height, steps, spiral_width, 1, rotation
			, outer_shell_radius-spiral_width/2-overlap,clockwise);
	else
		spiral_tube(height, steps, spiral_width, spiral_width/2, rotation
			, outer_shell_radius-spiral_width/2-overlap,clockwise);
	
	// domed mouth of pill collector
	translate([0, -(outer_shell_radius-spiral_width/2)+1, height+7-overlap])
	difference()
	{
		sphere(r=spiral_width/2+2);
		if (fill == NOFILL)
		{
			sphere(r=spiral_width/2-wall_width+1);
		}
		// clip the sphere to:

		//  open it to the drop bridge 
		rotate([0,75,0])
		cylinder(r=spiral_width,h=spiral_width+overlap);

		//  open it to the spiral tube
		translate([0,0,-7])
		rotate([0,-180,0])
		cylinder(r=spiral_width,h=spiral_width+overlap);

	}

	// blocking wall above domed mouth.
	// The blocking wall runs from the inner shell to the outer shell
	// closing the gap above the doomed mouth so that pills can't bounce out
	// above it.
	
	difference()
	{
	translate([-wall_width/2,-(outer_shell_radius-wall_width/2)
		,height //+ bottom-dome_radius
		//  
	])
	rotate([0,-15,0])
	cube([wall_width
		, outer_shell_radius-inner_shell_radius + wall_width
		, cartridge_lid_base - (height + bottom + 15)
]);

		// fit the base of the blocking wall to the dome.
		translate([0, -(outer_shell_radius-spiral_width/2)+1, height+7-overlap])
		sphere(r=spiral_width/2-wall_width+1);

	}

}

/** mounting for the dump chute server as well as the interconnection widget
 * Link to potential servo.
 * http://www.ebay.com.au/itm/Spring-RC-SM-S4306R-Continuous-Rotation-Robot-Servo-15KG-360-degree-for-Robot-/221642671116?pt=LH_DefaultDomain_0&hash=item339aeec40c 
 */
module dump_chute_servo()
{
  servo_mockup(
    servo_width = dump___servo_width,
    servo_length = dump___servo_length,
    servo_height = dump___servo_height,
    frame_length = dump___frame_length,
    frame_thickness = dump___frame_thickness,
    frame_v_offset = dump___frame_v_offset,
    mounting_hole_diameter = dump___mounting_hole_diameter,
    mounting_hole_center_x_offset = dump___mounting_hole_center_x_offset,
    mounting_hole_center_y_offset = dump___mounting_hole_center_y_offset,
    mounting_hole_slot = dump___mounting_hole_slot,
    axle_diameter = dump___axle_diameter,
    axle_height = dump___axle_height,
    axle_is_round = true,
    turret_diameter = dump___turret_diameter,
    turret_x_margin = dump___turret_x_margin,
    turret_y_margin = dump___turret_y_margin,
    turret_height = dump___turret_height,
    centered=true);
}




module place_chute(fill)
{
	translate([0,0,30])
	rotate([0,0,20])
	pill_chute(ANTICLOCKWISE, fill);


}


module pill_chute(clockwise, fill)
{
	bottom = 25;
	height = 60;
	steps=40;		// increase to get a smoother spiral
	rotation=60; // degrees of rotation for spiral
	dome_radius = spiral_width/2+2;

	if (fill == NOFILL)
		spiral_tube(height, steps, spiral_width, 1, rotation
			, outer_shell_radius-spiral_width/2-overlap,clockwise);
	else
		spiral_tube(height, steps, spiral_width, spiral_width/2, rotation
			, outer_shell_radius-spiral_width/2-overlap,clockwise);
	
	// domed mouth of pill collector
	translate([0, -(outer_shell_radius-spiral_width/2)+1, height+7-overlap])
	difference()
	{
		sphere(r=dome_radius);
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
	
	// blocking wall above doomed mouth.
	// The blocking wall runs from the inner shell to the outer shell
	// closing the gap above the doomed mouth so that pills can't bounce out
	// above it.
	
	difference()
	{
		translate([-wall_width/2,-(outer_shell_radius-wall_width/2)
			,height])
		rotate([0,15,0])
		cube([wall_width
			, outer_shell_radius-inner_shell_radius + wall_width
			, cartridge_lid_base - (height + bottom + 5)
		]);

		// fit the base of the blocking wall to the dome.
		translate([0, -(outer_shell_radius-spiral_width/2)+1, height+7-overlap])
		sphere(r=spiral_width/2-wall_width+1);

	}
}


module shell()
{
	// outer body
	difference()
	{
		cylinder(r=outer_shell_radius, h=outer_shell_height);
		translate([0,0,wall_width+1])
		cylinder(r=outer_shell_radius-wall_width, h=outer_shell_height);

		if (show_shell_base==false)
		{
			translate([0,0,-1])
			cylinder(r=outer_shell_radius-wall_width, h=outer_shell_height);
		}
			
		carve_collector();
	}

}

module inner_shell()
{
	cut_out_radius=cartridge_lid_base;

	// inner body
	difference()
	{
		cylinder(r=inner_shell_radius, h=inner_shell_height);
		translate([0,0,-overlap])
		cylinder(r=inner_shell_radius-wall_width/2, h=inner_shell_height+overlap*2);
		translate([0,cut_out_radius/2+30,cartridge_lid_base+10])
		sphere(r=cut_out_radius);
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
	axle_radius = 3;
	servo_connector_radius=4;

	color("grey")
	
	// build the bridge
	rotate([angle,0,-90])
	difference()
	{
		intersection()
		{
			union()
			translate([0,-length/2,0])
			{
				// flat plate of the dump bridge
				cube([width,length,wall_width]);
			

				// pivot connector
				translate([axle_radius+2+gap,length/2-axle_radius,-axle_radius*2+overlap])
				cube([width-axle_radius*4-gap*2,axle_radius*2,axle_radius*2]);
				// centre pivot for the bridge.
				translate([0,length/2,-axle_radius*2])
				rotate([0,90,0])
				cylinder(r=axle_radius, h=width);

				// Servo connector
				translate([0,length,-axle_radius])
				rotate([0,90,0])
				difference()
				{
					cylinder(r=servo_connector_radius, h=4);
					translate([0, 0,-overlap])
					cylinder(r=servo_connector_radius/2, h=6);
				}

			}
			// round the outer edge of the bridge to fit the external wall.
			translate([-outer_shell_radius+width,0,-10])
			cylinder(r=outer_shell_radius-wall_width-gap, h=15);
		}
		// round the inner edge of the bridge.
		translate([-(outer_shell_radius-spiral_width)/2-22,0,-11])
		cylinder(r=outer_shell_radius-spiral_width+gap*3, h=15);
	}

	// pivot mounts for the bridge.

	// mount on inner shell
	translate([0,0,-axle_radius*2])
	rotate([90,0,0])
	difference()
	{
		cylinder(r=axle_radius*2, h=5, r2=axle_radius+gap*2);
		translate([-axle_radius+gap,0,-10])
		cube([axle_radius*2-gap*2, axle_radius*2, 50]);
		translate([0,0,-overlap])
		cylinder(r=axle_radius+gap, h=10);
	}


	// mount on outer shell
	translate([0	, -width+overlap*2,-axle_radius*2])
	rotate([90,0,180])
	difference()
	{
		cylinder(r=axle_radius*2, h=5, r2=axle_radius+gap*2);
		translate([-axle_radius+gap,2,-overlap])
		
		cube([axle_radius*2-gap*2, axle_radius*2, 50]);	
		translate([0,0,-overlap])
		cylinder(r=axle_radius+gap, h=10);
	}

	
}


module drawer()
{
	drawer_depth=30;
	drawer_width=60;
	
	translate([0,0,drawer_depth+wall_width])
	rotate([0,180,0])
	difference()
	{
	/*
	 * outer drawer frame
	 */ 
		
		difference()
		{
			translate([0,-drawer_width/2,0])
			cube([85,drawer_width,drawer_depth]);
			//overlap*2
			translate([0,0,-overlap])
			difference	()
			{											 
				cylinder(r=100,h=drawer_depth+overlap*2);
				cylinder(r=75,h=drawer_depth);
			}
		}
	
	/*
	 * Create the void inside the draw.
	 */
		
		difference()
		{
			translate([0+wall_width,-drawer_width/2+wall_width,-overlap])
			cube([85-wall_width*2,drawer_width-wall_width*2,drawer_depth+overlap-wall_width]);
			//overlap*2
			translate([0,0,-overlap])
			difference	()
			{											 
				translate([0,0,-overlap])
				cylinder(r=87,h=drawer_depth+overlap*2);
				translate([0,0,-overlap])
				cylinder(r=75-wall_width,h=drawer_depth+overlap*2);
			}
			//translate([0,0,-overlap])
			//cylinder(r=hub_radius+wall_width,h=drawer_depth+overlap*2);
			cylinder(r=inner_shell_radius+wall_width+gap*2,h=drawer_depth+overlap*2);


		}

			translate([0,0,-overlap])
			cylinder(r=inner_shell_radius+gap*2,h=drawer_depth+overlap*2);

	}
}



module cartridge()
{
	// Outer skin
	difference()
	{
		translate([0,0,1])
		cylinder(r=cartridge_radius, h=cartridge_height-3);
		translate([0,0,wall_width])
		cylinder(r=cartridge_radius-2, h=cartridge_height);
		translate([0,0,-20])
		cylinder(r=hub_radius-2, h=cartridge_height+wall_width+100);
		translate([0,0,0])
		rotate([0,0,1.5])
		wedge(cartridge_height+wall_width, cartridge_radius-wall_width, 360/14 - 3);

	

	}

	// add a slight campher on the outer edge so it meshes with the
	// small tags on the lid. The tags are designed to hold the 
	// cartridge in place when it is turned up side down.
	translate([0,0,-98])
	difference()
	{
			translate([0,0,-1])
			cylinder(r=0, r2=cartridge_lid_radius-wall_width*2, h=100);
			translate([0,0,-3])
			cylinder(r=cartridge_lid_radius-wall_width-4, h=100);
		translate([0,0,90])
		rotate([0,0,1.5])
			wedge(cartridge_height+wall_width, cartridge_radius-wall_width, 360/14 - 3);
		translate([0,0,-20])
		cylinder(r=hub_radius-2, h=cartridge_height+wall_width+100);	

	}

//TODO: segments only just meet hub.

	// create the pill segments.
	difference()
	{
		for ( rot = [0 :  14])
		{
			rotate([0,0,(22 + 2) * rot])
			cube([cartridge_radius-1, wall_width, cartridge_height]);
		}
		
		// remove the segments from the innner hub
		translate([0,0,-10])
		cylinder(r=hub_radius, h=cartridge_height*2);	
	}

	// inner hub
	difference()
	{
		cylinder(r=hub_radius, h=cartridge_height-2);

		
		translate([0,0,-10])
		cylinder(r=hub_radius-2, h=cartridge_height+10);	
	}


	// add little tags to make it easy to extract the cartridge
	rotate([0,0,90])
	translate([hub_radius,0,-1+overlap])
	cylinder(r=hub_radius/3, h=wall_width);

	rotate([0,0,270])
	translate([hub_radius,0,-1+overlap])
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
			cylinder(r=motor_shaft_radius, h=cartridge_height+wall_width*8);
			translate([motor_shaft_radius/2, -motor_shaft_radius,5 ])			
			cube([motor_shaft_radius*2,motor_shaft_radius*2, motor_shaft_radius*3]);
		}
		

		// prongs wholes for fork connector
		translate([raised_hub_radius/2, 0,-4+overlap])
		cylinder(r=prong_radius, h=prong_height);
	
		translate([-raised_hub_radius/2, 0,-4+overlap])
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
module motor_connector()
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
			cylinder(r=motor_shaft_radius, h=cartridge_height+wall_width*8);
			translate([motor_shaft_radius/2, -motor_shaft_radius, 0])
			cube([motor_shaft_radius*2,motor_shaft_radius*2, motor_shaft_radius*2]);
		}
	}

}

module cartridge_lid()
{
	// set the default draw location centre to 0,0,0
	translate([0,0,canister_height])
	rotate([180,0,-79])
	{	
		difference()
		{
			cylinder(r=cartridge_lid_radius, h=canister_height);
			translate([0,0,-wall_width])
			{
				// hollow out the main cylinder
				cylinder(r=cartridge_lid_radius-wall_width*2, h=canister_height);
	
				//rotate(-7)
				difference()
				{
				// First wedge for pill cavity is a complete cut through
				wedge(canister_height+10, cartridge_lid_radius-wall_width-4, 360/14 - 2);
				//cylinder(r=cartridge_lid_radius/3, h=canister_height+10);
				cylinder(r=inner_shell_radius, h=canister_height+10);
				}
			}
	
		// hole to engage the central hub of the cartridge.
		// central raised hob - used to engage with lid
		translate([0,0,canister_height-4])
		cylinder(r=hub_radius-4, h=wall_width*3+overlap);
			
		}
	
		// Add a segmented rim around the inside edge which
		// snaps beind the cartridge to hold the cartridge in place.
		difference()
		{
			cylinder(r=cartridge_lid_radius, h=wall_width*4);
			translate([0,0,-3])
			cylinder(r=cartridge_lid_radius-wall_width*4, h=wall_width*6);
	
			// we just want three lips left so lets cut some wedges out.
			translate([0,0,-1])
			wedge(canister_height+10, cartridge_lid_radius-wall_width-2, 100);
			translate([0,0,-1])
			rotate([0,0,120])
			wedge(canister_height+10, cartridge_lid_radius-wall_width-2, 100);
			translate([0,0,-1])
			rotate([0,0,240])
			wedge(canister_height+10, cartridge_lid_radius-wall_width-2, 100);
			
			// campher the edges to 45 degrees - so we can 3d print.
			translate([0,0,-canister_height*2-2])
			cylinder(r=0, r2=cartridge_lid_radius-wall_width*2, h=100);
			translate([0,0,5])
			cylinder(r=cartridge_lid_radius-wall_width-2, h=wall_width*6);
		}
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
//			spiral_tube(height, 100, spiral_width, 3, 60, outer_shell_radius-spiral_width/2-overlap,-1);
		

	}
}

module carve_collector()
{
	translate([outer_shell_radius, 20,collector_end_radius])
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
	translate([-outer_shell_radius+50, outer_shell_radius-10,95])
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
		cylinder(r=motor_radius, h=motor_height);
	
		// shaft
		translate([0,0,motor_height])
		cylinder(r=motor_shaft_radius, h=motor_shaft_height);
	
		// collar
		translate([0,0,motor_height])
		cylinder(r=motor_collar_radius, h=4);
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


