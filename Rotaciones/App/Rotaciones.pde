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
* 11/09/2018: Cambio la cantidad de ranuras a 32, que es la cantidad de transiciones en la zebra.
*  Hay que rediseñar el código para poner el número de franjas como constante.
* 
* To do:
*
*/

import processing.serial.*;
import g4p_controls.*;

Serial port;

//Controles
GButton Reiniciar;

//Variables
int ps;
float ws[] = new float[5];
float wsSmooth;
int time;

//Constantes
int STRIPS = 32;

void setup(){
 size( 800, 600 );
 if( openComm() == 1 ){
   println( "No hay ningún colorímetro conectado" );
   exit();
 }
 
 Reiniciar = new GButton(this, width*0.8, height*0.9, 90, 30, "Reiniciar"); 
}


void draw(){
  println(round(wsSmooth*100)/100.0);
  delay(300);
}

void serialEvent(Serial port) { 
  String inString = port.readString();
  if( inString.contains("1") ){
    ps++;
    float wsTmp = 2.0*PI/float(STRIPS)/(millis() - time)*1000.0;
    for( int i=0; i<4; i++ ){
      ws[i] = ws[i+1];
    }
    ws[4] = wsTmp;
    wsSmooth = 0;
    for( int i = 0; i<5; i++){
      wsSmooth += ws[i];
    }
    wsSmooth /= 5;
    time = millis();
  }
}

public void handleButtonEvents(GButton button, GEvent event) {
  if( button == Reiniciar ){
    
  }
}

int openComm() {
  String[] serialPorts = Serial.list(); //Get the list of tty interfaces
  for ( int i=0; i<serialPorts.length; i++) { //Search for ttyACM*
    if ( serialPorts[i].contains("ttyACM") || serialPorts[i].contains("ttyUSB0") || serialPorts[i].contains("COM") ) {  //If found, try to open port.
      println(serialPorts[i]);
      try {
        port = new Serial(this, serialPorts[i], 115200);
        port.bufferUntil(10);
      }
      catch(Exception e) {
        return 1;
      }
    }
  }
  if (port != null)
    return 0;
  else
    return 1;
}