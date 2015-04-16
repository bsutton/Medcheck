/**
 * spirals
 */


/**
 * drawers a spiral. The top spiral (stair) is aligned with the x-axis
 *  with the spiral wrapping around the z-axis towards the y-axis if 
 *  the spiral is clockwise or the -ve y-axis if the spiral is counter-clockwise.
 * The spiral is drawern as a series of steps. If there are enough stairs
 * then the spiral looks smooth.
 *
 * height - the hight of the spiral
 * steps - the more steps the finer the spiral and the longer it takes to drawer.
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




/**
 * drawers a spiral. The top spiral (stair) is aligned with the x-axis
 *  with the spiral wrapping around the z-axis towards the y-axis if 
 *  the spiral is clockwise or the -ve y-axis if the spiral is counter-clockwise.
 * The spiral is drawern as a series of steps. If there are enough stairs
 * then the spiral looks smooth.
 *
 * height - the hight of the spiral
 * steps - the more steps the finer the spiral and the longer it takes to drawer.
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
