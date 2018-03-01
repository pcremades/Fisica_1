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
* Descripción: Sistema de adquisición de datos de la rueda. Calcula la velocidad angular.
*  Determina la velocidad angular máxima. Determina el coeficiente de amortiguamiento
*  lineal.
*
* Uso:
*  - Conecte el sistema de adquisición de la rueda. Presione 'r' para reiniciar.
* Change Log:
* 
* To do:
*
*/

import processing.serial.*;

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


void setup(){
  size(800, 600);
  //noLoop();
  serialPorts = Serial.list(); //Get the list of tty interfaces
  for( int i=0; i<serialPorts.length; i++){ //Search for ttyACM*
    if( serialPorts[i].contains("ttyUSB") ){  //If found, try to open port.
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
void serialEvent( Serial port ){
    ps_old = ps;
    while(port.available() > 0){
    inByte = port.readChar();
    if( inByte == '2' || inByte == '1' ){  //Si se recibe un '2' o '1', incrementar la posición en 1. Esta previsto poder detectar sentido de giro.
      ps++;
      ws1= 2.0*PI/64.0/(millis() - time1)*1000.0;  //Calcula la velocidad angular instantánea.
      /*wsArray[iWS] = ws1;
      iWS++;
      if(iWS > 9)
        iWS=0;*/
      time1 = millis();
    }
 }
 //diffTime = millis() - time1;
}


void draw(){
  background(200);
  theta = ps*2*PI/168.0; // Posición en radianes
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
  if( millis() - time > 500.0 ){
    ws = 2*PI*((ps - pulse1)/168.0)/(millis() - time)*1000.0;  //Velocidad angular media cada 300ms
    /*for( int k=0; k<nWS; k++){
     ws = ws + wsArray[k];
    }*/
    //ws=;
    time = millis();
    pulse1 = ps;
    vs = ws * 0.15;  //Velocidad tangencial.
    /*print(time);
    print(" ");
    print(ps);
    print(" ");
    println(ws1);*/
  }
  
  //Busca la velocidad angular máxima
  if( ws > maxWS*1.1 ){
   maxWS = ws;
   Tau = millis();
   lookformin = 1;
  }
  //Calcula el coeficiente de amortiguamiento cuando la velocidad angular
  //ha caído a 0.1 rad/s.
  else if( (ws < 0.1) && (lookformin == 1) ){
   Tau = -maxWS/(millis() - Tau)*1000;
   lookformin = 0;
  }
    
  fill(150,20,20);
  textSize(24);
  text("Velocidad Angular = "+round(ws*100)/100.0, -width/2 + 30, -height/2 + 30);
  //text(ws, -100, -100);
  text("Máxima Velocidad Angular = "+round(maxWS*100)/100.0, -width/2 + 30, -height/2 + 70);
  //text(maxWS, -50, 150);
  //text("Alfa = "+round(Tau*100)/100.0, -width/2 + 30, -height/2 + 110);
  //text(Tau, -190, 170);
  textSize(14);
  fill(250,20,20);
  text("Presione 'R' para reiniciar", -width/2 + 30, height/2-20);
}