/* Copyright 2015 Pablo Cremades //<>//
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
* Fecha: 15/03/2018
* e-mail: pablocremades@gmail.com
* Descripción: 
*
* Change Log:
* 
*/

import g4p_controls.*; //<>//
import processing.serial.*;

String[] serialPorts;
Serial port;
GButton Iniciar, Detener;
String inString = "";
String[] list;
float tiempo=0, tiempo1=0;
int sensorStatus = 0;
boolean pass = false;

void setup(){
  size(400, 300);
  serialPorts = Serial.list(); //Get the list of tty interfaces
  for( int i=0; i<serialPorts.length; i++){ //Search for ttyACM*
    if( serialPorts[i].contains("ttyACM") ){  //If found, try to open port.
                println(serialPorts[i]);
      try{
        port = new Serial(this, serialPorts[i], 115200);
        port.bufferUntil(10);
      }
      catch(Exception e){
      }
    }
  }
  
  //Create the buttons.
  Iniciar = new GButton(this, 20, 20, 100, 30, "Iniciar");
  Detener = new GButton(this, 150, 20, 100, 30, "Detener");}

void draw(){
  background(255);
  fill(0);
  if( port == null ){  //If failed to open port, print errMsg and exit.
    println("Equipo desconectado. Conéctelo e intente de nuevo."); //<>//
    exit();
  }
 
 //If there is a string available on the port, parse it.
 //Strings not begining with # are data from SAD.
 if(inString.length() > 5 && inString.charAt(0) != '#'){
   //print(inString);
   list = split(inString, "\t"); //Split the string.
   int sensor = Integer.parseInt(list[0]) - 2; //Los sensores digitales son 2 y 3. Restamos 2 para usar de index (0 y 1).
   if( sensor == 0 || sensor == 1 ){
     int status = Integer.parseInt(list[2].trim());  //Status is in the 3rd substring
     if( status == 1 )
     {
       tiempo = millis() - tiempo;
       if( pass == false ){
         pass = true;
         tiempo1 = 0;
         tiempo1 = tiempo;
       }
       else if( pass == true ){
         pass = false;
         tiempo1 = tiempo1 + tiempo;
         println(tiempo1);
         tiempo1 = 0;
       }
       tiempo = millis();
     }
   }
   inString = ""; //Empty the string.
 }
}

//Read the incoming data from the port.
void serialEvent(Serial port) { 
  inString = port.readString();
}

//Buttons event handler.
void handleButtonEvents(GButton button, GEvent event) {
   if(button == Iniciar && event == GEvent.CLICKED){
      port.write("#0001");  //Inicio.
      delay(100);
      port.write("#0031 462815232 1943863296 831782912 1421148160 ");  //Código de autenticación
      delay(100);
      port.write("#0033 239589820 3486795892 3188765557 2136465651 ");  //Código de autenticación
      delay(100);
      port.write("#0007");
      delay(100);
      port.write("#0005,2,3,2,3,10,1,0,1,1,1,1,1,1,1");  //Sensor 0
      delay(100);
      port.write("#0005,3,3,2,3,15,1,0,1,1,1,1,1,1,1");  //Sensor 1
      delay(100);
   }
   else if(button == Detener && event == GEvent.CLICKED){
      port.write("#0021"); //Close comunication.
      exit(); //Exit the app.
   }
}