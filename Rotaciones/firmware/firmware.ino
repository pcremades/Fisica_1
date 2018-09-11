/* Copyright 2018 Pablo Cremades
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
* Fecha: 20/08/2018
* e-mail: pcremades@fcen.uncu.edu.ar
* Descripción: firmware para Arduino para el sistema de rotaciones.
*
*/

// Pin 2 es la entrada del fotodetector

void setup() {
  Serial.begin(115200);
//Usamos pullups externos de 330kOhm para mejorar la sensibilidad.
  pinMode(2, INPUT);
  attachInterrupt(INT0, IRD1int, CHANGE);
}

void loop() {
  
}

//ISR para la fotocompuerta 1. Imprime un mensaje compatible con el protocolo INGKA.
void IRD1int ()
{
    Serial.println("1");
}

