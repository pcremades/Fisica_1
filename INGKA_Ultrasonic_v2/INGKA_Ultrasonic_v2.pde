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
* Fecha: 08/03/2017
* e-mail: pablocremades@gmail.com
* Descripción: Aplicación para registrar la posición de un móvil sobre el riel de aire
* utilizando el sensor ultrasónico. La aplicación también calcula la velocidad instantánea.
* Para comenzar a medir presione el botón "Iniciar". Cuando termine, presione el botón "Detener".
*
* Change Log:
****************************************************************************************/
import g4p_controls.*;
import processing.serial.*;
import grafica.*;

GButton Iniciar, Detener, X_MIN, X_MAX;

GPlot plotPos, plotSpeed;
GPointsArray points;

String[] serialPorts;
Serial port;
String inString = "";
String[] list;
float[] tiempo = new float[2];
int tiempoInt;
float tiempoStart;
//int[] sensorStatus = {0, 0};
//float[] sensorSpeed = new float[2];
float[] position = new float[11];  //vector de posiciones para aplicar filtro.
float[] posMean = new float[11];  //vector de posiciones filtradas

//coeficientes de Butterworth orden 3, fc=0.3Hz
float[] butterCoefB = {0.049533,   0.148599,   0.148599,   0.049533};
float[] butterCoefA = {-1.16192,   0.69594,  -0.13776};
//coeficientes de Butterworth orden 3, fc=0.1Hz
//float[] butterCoefB = {0.0028982,   0.0086946,   0.0086946,   0.0028982};
//float[] butterCoefA = {-2.37409,   1.92936,  -0.53208};

float dt=100;  //Intervalo de tiempo entre mediciones
int status=0;

int pointsCount=0;  //Cantidad de puntos que se han graficado.
int nPoints = 300;  //Cantidad máxima de puntos a graficar.
boolean record = true;

//float positionOld;
float xMin, xMax;  //Posiciones de referencia separadas 20cm sobre el riel.

//float Tpo;

void setup(){
  size(1200, 640);
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
  Iniciar = new GButton(this, 900, 20, 100, 30, "Iniciar");
  Detener = new GButton(this, 1050, 20, 100, 30, "Detener");
  X_MIN = new GButton(this, 900, 250, 100, 30, "X_min");
  X_MAX = new GButton(this, 1050, 250, 100, 30, "X_max");
  
  // Prepare the points for the plot
  points = new GPointsArray(nPoints);
  
  // Create a new plot and set its position on the screen
  plotPos = new GPlot(this);
  plotPos.setPos(25, 25);
  plotPos.setDim(700, 200);
  // or all in one go
  // GPlot plot = new GPlot(this, 25, 25);
  //plot.setYLim(0, 500);
  plotPos.setYLim(-2, 50);

  // Set the plot title and the axis labels
  plotPos.setTitleText("Posición");
  //plotPos.getXAxis().setAxisLabelText("x axis");
  //plotPos.getYAxis().setAxisLabelText("y axis");

  // Add the points
  plotPos.setPoints(points);
  
  plotSpeed = new GPlot(this);
  plotSpeed.setPos(25, 330);
  plotSpeed.setDim(700, 200);
  // or all in one go
  // GPlot plot = new GPlot(this, 25, 25);
  //plot.setYLim(0, 500);
  plotSpeed.setYLim(-0.2, 0.2);

  // Set the plot title and the axis labels
  plotSpeed.setTitleText("Velocidad");
  //plotSpeed.getXAxis().setAxisLabelText("x axis");
}

void draw(){
  background(150);
  
  plotPos.beginDraw();
  plotPos.drawBackground();
  plotPos.drawBox();
  plotPos.drawXAxis();
  plotPos.drawYAxis();
  plotPos.drawTopAxis();
  plotPos.drawRightAxis();
  plotPos.drawTitle();
  plotPos.drawGridLines(GPlot.BOTH);
  plotPos.getXAxis().getAxisLabel().setText("Tiempo [ms]");
  plotPos.getYAxis().getAxisLabel().setText("Distancia [cm]");
  plotPos.getMainLayer().drawPoints();
  plotPos.endDraw();
  
  plotSpeed.beginDraw();
  plotSpeed.drawBackground();
  plotSpeed.drawBox();
  plotSpeed.drawXAxis();
  plotSpeed.drawYAxis();
  plotSpeed.drawTopAxis();
  plotSpeed.drawRightAxis();
  plotSpeed.drawTitle();
  plotSpeed.drawGridLines(GPlot.BOTH);
  plotSpeed.getXAxis().getAxisLabel().setText("Tiempo [ms]");
  plotSpeed.getYAxis().getAxisLabel().setText("Velocidad [m/s]");
  plotSpeed.getMainLayer().drawPoints();
  plotSpeed.endDraw();
  
  fill(0);
  if( port == null ){  //If failed to open port, print errMsg and exit.
    println("Equipo desconectado. Conéctelo e intente de nuevo.");
    exit();
  }
 
  if( keyPressed ){
  //Cerrar comunicación y desconectar sensores.
  if( key == 'c' ){
    port.write("#0021");
    exit();
  }
  //Inicio de la comunicación.
  else if( key == 's' ){
    port.write("#0001");  //Inicio.
    delay(100);
    port.write("#0031 462815232 1943863296 831782912 1421148160 ");  //Código de autenticación
    delay(100);
    port.write("#0033 239589820 3486795892 3188765557 2136465651 ");  //Código de autenticación
    delay(100);
    port.write("#0007"); //Configurar sensor ultrasónico.
    delay(100);
    port.write("#0005,2,2,3,1,100,1,6000,1,1,1,1,1,1,1");  //Sensor 0
    delay(100);
  }
  else if( key == 'r' )
    record = !record;
  else if( key == 'm' )
    xMin = posMean[5];
  else if( key == 'M' )
    xMax = posMean[5];
 }
 
 //If there is a string available on the port, parse it.
 //Strings not begining with # are data from SAD.
 if(inString.length() > 5 && inString.charAt(0) != '#'){
   //println(Tpo - millis());
   //Tpo = millis();
   //print(inString);
   list = split(inString, "\t"); //Split the string.
   tiempo[0] = Float.parseFloat(list[1]);
   //Buffer FILO para almacenar las posiciones
   for( int k=0; k<=9; k++){
    position[k] = position[k+1];
    posMean[k] = posMean[k+1];
   }
   position[10] = Float.parseFloat(list[2].trim());
   if(status==0){
    tiempoStart = tiempo[0];
    status = 1;
   }
   tiempo[0] -= tiempoStart;
   tiempoInt = round(tiempo[0]/1000); 
 
 int xPos = tiempoInt/50;
 //int yPos = round(position[3]/10);

 float Pdiff_1 = posMean[6] - posMean[4];
 float Pdiff_2 = posMean[7] - posMean[3];
 float Pdiff_3 = posMean[8] - posMean[2];
 float Pdiff_4 = posMean[9] - posMean[1];
 float Pdiff_5 = posMean[10] - posMean[0];

 //float speed = (5*Pdiff_1 + 4*Pdiff_2 + Pdiff_3)/(0.1*32); //Derivada exacta hasta orden 2 de 5 puntos.
 float speed = (42*Pdiff_1 + 48*Pdiff_2 + 27*Pdiff_3 + 8*Pdiff_4 + Pdiff_5)/(0.1*512)*20/(xMax - xMin)/100; //Derivada exacta hasta orden 2 de 11 puntos.
 float accel = (-7*Pdiff_4 + 12*Pdiff_3 + 52*Pdiff_2 - 12*Pdiff_1)/(192*0.01);
 println(accel);
 
 //Aplicamos un filtro simple promediador sobre los 11 puntos.
 float posAvg = position[0];
 /*for( int i=0; i<11; i++)
   posAvg += position[i];
 posAvg /= 11;
 posMean[10] = posAvg;*/
 for( int k=0; k<=9; k++){
    posMean[k] = posMean[k+1];
   }
 posAvg = butterCoefB[0]*position[10]+butterCoefB[1]*position[9]+butterCoefB[2]*position[8]+butterCoefB[3]*position[7]-
          butterCoefA[0]*posMean[9]-butterCoefA[1]*posMean[8]-butterCoefA[2]*posMean[7];
 //println(posAvg);
 posMean[10] = posAvg;
 
 
 if( record == true ){
   float posCM = (posMean[10] - xMin)*20/(xMax - xMin);
 if(pointsCount < nPoints){
   plotPos.addPoint(xPos, posCM);
   plotSpeed.addPoint(xPos, speed);
   pointsCount++;
 }
 else{
   plotPos.removePoint(0);
   plotSpeed.removePoint(0);
   plotPos.addPoint(xPos, posCM);
   plotSpeed.addPoint(xPos, speed);
 }
 }
 
 inString = "";
 }
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
    port.write("#0007"); //Configurar sensor ultrasónico.
    delay(100);
    port.write("#0005,2,2,3,1,100,1,6000,1,1,1,1,1,1,1");  //Sensor 0
    delay(100);
   }
   else if(button == Detener && event == GEvent.CLICKED){
      port.write("#0021"); //Close comunication.
      exit(); //Exit the app.
   }
   else if(button == X_MIN && event == GEvent.CLICKED){
      xMin = posMean[5];
   }
   else if(button == X_MAX && event == GEvent.CLICKED){
      xMax = posMean[5];
   }
}

//Read the incoming data from the port.
void serialEvent(Serial port) { 
  inString = port.readString();
}