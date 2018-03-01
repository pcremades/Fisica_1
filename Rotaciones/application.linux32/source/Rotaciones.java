import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.serial.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Rotaciones extends PApplet {

/* Copyright 2015 Pablo Cremades
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
/**************************************************************************************
* Autor: Pablo Cremades
* Fecha: 3/11/2015
* e-mail: pcremades@fcen.uncu.edu.ar.
* Descripci\u00f3n: Sistema de adquisici\u00f3n de datos de la rueda. Calcula la velocidad angular.
*  Determina la velocidad angular m\u00e1xima. Determina el coeficiente de amortiguamiento
*  lineal.
*
* Uso:
*  - Conecte el sistema de adquisici\u00f3n de la rueda. Presione 'r' para reiniciar.
* Change Log:
* 
* To do:
*
*/



Serial port;
int ps, ps_old;
float ws, vs, g, ws1, maxWS, Tau;
float[] wsArray;
int iWS=0;
int nWS;
float theta;
float time=1, time1, diffTime;
char inByte;
int pulse1;
float radio=100;
int lookformin;

String[] serialPorts;


public void setup(){
  
  //noLoop();
  serialPorts = Serial.list(); //Get the list of tty interfaces
  for( int i=0; i<serialPorts.length; i++){ //Search for ttyACM*
    if( serialPorts[i].contains("ttyACM") ){  //If found, try to open port.
                println(serialPorts[i]);
      try{
        port = new Serial(this, serialPorts[i], 115200);
        port.bufferUntil('\r');
      }
      catch(Exception e){
      }
    }
  }
  frameRate(30);
  ellipseMode(RADIUS);
  wsArray = new float[nWS];
}

//ISR para procesar datos del puerto serie.
public void serialEvent( Serial port ){
    ps_old = ps;
    while(port.available() > 0){
    inByte = port.readChar();
    if( inByte == '2' || inByte == '1' ){  //Si se recibe un '2' o '1', incrementar la posici\u00f3n en 1. Esta previsto poder detectar sentido de giro.
      ps++;
      ws1= 2.0f*PI/168.0f/(millis() - time1)*1000.0f;  //Calcula la velocidad angular instant\u00e1nea.
      /*wsArray[iWS] = ws1;
      iWS++;
      if(iWS > 9)
        iWS=0;*/
      time1 = millis();
    }
 }
 //diffTime = millis() - time1;
}


public void draw(){
  background(200);
  theta = ps*2*PI/168.0f; // Posici\u00f3n en radianes
  translate(width/2, height/2);
  fill(0, 200, 255);
  ellipse(0,0, radio, radio);
  line(0,0, radio*cos(theta), radio*sin(theta));
  
  //Presinar 'r' para reiniciar.
  if( keyPressed ){
    if( key == 'r' ) 
      ps = 0;
      maxWS = 0;
  }
  
  //Imprime serie de datos cada 300ms
  if( millis() - time > 500.0f ){
    ws = 2*PI*((ps - pulse1)/168.0f)/(millis() - time)*1000.0f;  //Velocidad angular media cada 300ms
    /*for( int k=0; k<nWS; k++){
     ws = ws + wsArray[k];
    }*/
    //ws=;
    time = millis();
    pulse1 = ps;
    vs = ws * 0.15f;  //Velocidad tangencial.
    /*print(time);
    print(" ");
    print(ps);
    print(" ");
    println(ws1);*/
  }
  
  //Busca la velocidad angular m\u00e1xima
  if( ws > maxWS*1.1f ){
   maxWS = ws;
   Tau = millis();
   lookformin = 1;
  }
  //Calcula el coeficiente de amortiguamiento cuando la velocidad angular
  //ha ca\u00eddo a 0.1 rad/s.
  else if( (ws < 0.1f) && (lookformin == 1) ){
   Tau = -maxWS/(millis() - Tau)*1000;
   lookformin = 0;
  }
    
  fill(150,20,20);
  textSize(24);
  text("Velocidad Angular = "+round(ws*100)/100.0f, -width/2 + 30, -height/2 + 30);
  //text(ws, -100, -100);
  text("M\u00e1xima Velocidad Angular = "+round(maxWS*100)/100.0f, -width/2 + 30, -height/2 + 70);
  //text(maxWS, -50, 150);
  //text("Alfa = "+round(Tau*100)/100.0, -width/2 + 30, -height/2 + 110);
  //text(Tau, -190, 170);
  textSize(14);
  fill(250,20,20);
  text("Presione 'R' para reiniciar", -width/2 + 30, height/2-20);
}
  public void settings() {  size(800, 600); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Rotaciones" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
