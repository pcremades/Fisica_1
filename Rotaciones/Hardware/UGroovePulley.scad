// -------- This module was created by Min T Lin	--------
// -------- on the 31/01/2014 and is available 		--------
// -------- for distribution without any 				--------
// -------- restrictions. 										--------


$fn=100;		// render resolution 100 works well for a nice and smooth surface

// Bearing dimensions
//radius=7.5;	// 2.7mm works well for a 5mm drive shaft
//outer_radius=20;
//thickness=5;
//groove_radius=1;
//circles=0;
//UGroovePulley(11,40,5,1,0);
//translate([0,0,5])
//UGroovePulley(11,20,5,1,0);

module UGroovePulley(radius, outer_radius, thickness, groove_radius, circles)
{difference()
    {
	difference()
	{
		// main body
		cylinder(r= outer_radius, h=thickness);
		
		// shaft cutout
		cylinder(r=radius, h=thickness);
	
		// groove
		translate([0, 0, thickness/2])
			rotate_extrude(convexity = 10)
				translate([outer_radius, 0,0])
					circle(r=groove_radius);
		
	}
    
    for(i=[0:circles-1])	
				rotate([0,0,i*360/circles])
				translate([(radius+(outer_radius-radius)/2),0,-1])
				cylinder(r=thickness/2,h=max(thickness)+3);
}
}

// run the module
//UGroovePulley();
