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
import grafica.*;


Serial port;

//Controles
GButton Reiniciar;
GPlot plotPos;

//Variables
int ps;
float tBuffer[] = new float[7];
float wsSmooth;
float wsMax;
int time;
GPointsArray ws;

//Constantes
int STRIPS = 32;
float arcPos = 2*PI/STRIPS;
int wsN=500;

void setup() {
  size( 800, 600 );
  if ( openComm() == 1 ) {
    println( "No hay ningún equipo conectado" );
    exit();
  }

  Reiniciar = new GButton(this, width*0.8, height*0.9, 90, 30, "Reiniciar"); 

  plotPos = new GPlot(this);
  ws = new GPointsArray(wsN);
  plotPos.setPoints(ws);
  plotPos.setPos(20, 20);
  plotPos.setDim(width *0.82, height*0.6);
  plotPos.setYLim(0, 8);
  plotPos.getTitle().setText("Velocidad angular vs Tiempo");
  plotPos.getXAxis().getAxisLabel().setText("Tiempo [s]");
  plotPos.getYAxis().getAxisLabel().setText("Velocidad angular [rad/s]");
}


void draw() {
  background(200);
  //text(round(wsSmooth*100)/100.0, width/2, height/2);
  plotPos.beginDraw();
  plotPos.drawBackground();
  plotPos.drawBox();
  plotPos.drawXAxis();
  plotPos.drawYAxis();
  plotPos.drawTitle();
  plotPos.drawGridLines(GPlot.BOTH);
  try {
    plotPos.getMainLayer().drawPoints();
  }
  catch( Exception e ) {
    println(e);//plotPos.getMainLayer().getPoints());
  }
  plotPos.endDraw();
  
  fill(150,20,20);
  textSize(24);
  //text("Velocidad Angular = "+round(ws*100)/100.0, -width/2 + 30, -height/2 + 30);
  text("Máxima Velocidad Angular = "+round(wsMax*100)/100.0, width/4 + 30, height - 70);
}

int wsIndex = 0;
void serialEvent(Serial port) { 
  String inString = port.readString();
  if ( inString.contains("1") ) {
    for ( int i=0; i<6; i++ ) {
      tBuffer[i] = tBuffer[i+1];
    }
    tBuffer[6] = millis()/1000.0;
    float t_diff1 = tBuffer[4] - tBuffer[2];
    float t_diff2 = tBuffer[5] - tBuffer[1];
    float t_diff3 = tBuffer[6] - tBuffer[0];
    wsSmooth = 32*arcPos/(5*t_diff1 + 4*t_diff2 + t_diff3);
    
    if(wsSmooth > wsMax)
      wsMax = wsSmooth;

    wsIndex++;
    if ( wsIndex > wsN ) {
      plotPos.removePoint(0);
    }
    plotPos.addPoint( tBuffer[2], wsSmooth );
    //plotPos.setPoints(ws);
  }
}

public void handleButtonEvents(GButton button, GEvent event) {
  if ( button == Reiniciar ) {
    wsMax = 0;
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
