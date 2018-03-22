// -------- Este módulo fue creado por Fernando Castro 	--------
// -------- on the 10/08/2016 y está disponible  para ser distribuido sin restricciones.

// Elementos que componen el carro

render_part(2);
module render_part(part_to_render) {
	if (part_to_render == 1) pestania();
    if (part_to_render == 2) basecompleta();
    if (part_to_render == 3) vastago();
}

// Dimensiones de la pestaña
ancho_p=15;
largo_p=25;
espesor_p=2;

// Dimensiones de la base del carro
ancho_b=35;
largo_b=100;
espesor_b=2;
    //Dimensiones soporte para pesos
    vastago_b=3.5;
    vastago_h=20;
    base=10;
    altura=10; 

module base(){
difference(){
cube(size=[ancho_b+espesor_b/2,largo_b,espesor_b]);
color("red")
rotate([0,-45,0])
cube(size=[espesor_b+espesor_b/2,largo_b*2+2,espesor_b*2],center=true);
}}

module traba_p()
{union(){
    color("red")
translate([0,ancho_p,espesor_b])
cube(size=[largo_p,espesor_p+1,espesor_p]);
color("red")
translate([largo_p,0,espesor_b])
cube(size=[espesor_p+1,ancho_p+espesor_p+1,espesor_p]);
}}

module soporte(){
color("green")
translate([ancho_b-base,largo_b/2,0])
difference(){
union(){
translate([-vastago_b/2,0,0])
rotate([0,0,45])
cylinder(altura,base,vastago_b,$fn=4);
rotate([0,0,45])
cylinder(altura-vastago_b/2,base*2,vastago_b,$fn=4);
}
translate([-vastago_b/2,0,0])
cube(size=[vastago_b,vastago_b,altura*2],center=true);
translate([base,0,0])
cube(size=[vastago_b*4,base*4,vastago_b],center=true);
}}
module basecompleta(){
union(){
base();
traba_p();
mirror([0,1,0])
translate([0,-largo_b,0])
traba_p();
soporte();
}}

module pestania(){
rotate([90,0,0])
union(){
    cube(size=[largo_p,ancho_p,espesor_p]);
translate([largo_p,0,0])
    rotate([0,-45,0])
cube(size=[largo_p,ancho_p,espesor_p]);
}}
module vastago(){
    rotate([90,0,0])
    cube(size=[vastago_b,vastago_b,vastago_h]);
    }