// -------- Este módulo fue creado por Fernando Castro 	--------
// -------- on the 10/08/2016 y está disponible  para ser distribuido sin restricciones.

// Soporte de polea para riel de aire FCEN

//Dimensiones de la tapa + porta polea
tubo=50;
espesor_t=2;
ancho_t=10;
d_polea=30;
d_ruleman=3;

difference(){
union(){
    linear_extrude(height =ancho_t+4*espesor_t,  convexity = 10){
polygon([[-10,-15],[-10,0],[-10,30],[10,35],[15,35],[15,30],[12.5,30],[0,0],[0,-15]]);}
translate([12.5,32.5,0])
cylinder(4,d_ruleman+1,d_ruleman+1);
translate([12.5,32.5,14])
cylinder(4,d_ruleman+1,d_ruleman+1);
}
color("red")
translate([10,30,4])
cube(size=[5,5,8]);
translate([12.5,32.5,0])
cylinder(2*ancho_t,d_ruleman/2,$fn=50);
color("red")
translate([12.5,32.5,2*espesor_t])
cylinder(ancho_t,d_polea/2+espesor_t,d_polea/2+espesor_t,$fn=50);
rotate([0,90,0])
translate([-9,-7.5,-4])
cylinder(4,4,4,$fn=50);
rotate([0,90,0])
translate([-9,10,-4])
cylinder(10,4,4,$fn=50);
rotate([0,90,0])
translate([-9,-7.5,-11])
cylinder(15,2,2,$fn=50);
rotate([0,90,0])
translate([-9,10,-11])
cylinder(20,2,2,$fn=50);
}

//color("red")
//translate([12.5,32.5,espesor_t+espesor_t/2])
//cylinder(ancho_t-espesor_t,d_polea/2,d_polea/2,$fn=50);
//color("red")
//translate([10,30,3])
//cube(size=[5,5,8]);
//color("red")
//translate([12.5,32.5,0])
//cylinder(4,d_ruleman,d_ruleman);
//color("red")
//rotate([0,90,0])
//translate([-9,-7.5,-11])
//cylinder(15,2,2,$fn=50);
////
//color("red")
//rotate([0,90,0])
//translate([-9,10,-11])
//cylinder(20,2,2,$fn=50);