

include<UGroovePulley.scad>
$fn=100;

rotate([180,0,0])
translate([0,0,5])
//render_part(1);
render_part(2);

module render_part(part_to_render) {
	if (part_to_render == 1) poleas();
	if (part_to_render == 2) plataforma();
}

module poleas(){

//GroovePulley(radius, outer_radius, thickness, groove_radius, circles)
UGroovePulley(12.5,40,5,1,0);
translate([0,0,5])
UGroovePulley(12.5,20,5,1,0);
}

module plataforma(){
translate([0,0,-5])
difference(){
//Disco plataforma
cylinder(5,50,50);
//Encastre para ruleman axial
cylinder(2,12.1,12.1);    
//Eje
cylinder(21,5.5,5.5);   

}
difference(){
    cylinder(20,11,11);
    cylinder(21,5.5,5.5);
    // Ranura
translate([0,-20,0])    #cube([3,40,40]);
    
 }}