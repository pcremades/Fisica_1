# Sistema para estudio de rotaciones

Este equipo está diseñado para realizar experimentos de rotaciones de cuerpos rígidos, conservación del momento angular y energía mecánica de rotación.

## Materiales

* Rodamiento axial URB 51100 (Diámetro interno 10mm; diámetro externo 24mm).

* Tornillo de 10mm con tuerca y arandelas.

* MDF o madera de 3mm de espesor (80cm x 30 cm aproximadamente).

* 100 gr. de ABS aproximadamente.

* Roldana con bajo rozamiento.

## Construcción

Cortar una placa rectangular de MDF de 30cm por 20cm que servirá de base para el equipo. Practicar un orificio de 10mm de diámetro como indica la figura 1.

![Fig 1](https://github.com/pcremades/Rotaciones/raw/master/Documentaci%C3%B3n/figs/fig1.png)
*Fig 1. Esquema vista superior de la base del sistema de rotaciones.*

En el extremo opuesto al que se hizo el orificio, fijar la roldana ligeramente descentrada (6cm – 8cm).

Colocar el tornillo con la tuerca y las arandelas necesarias en el orificio. Colocar el rodamiento axial en el tornillo. Colocar el sistema de poleas en el eje (ver sistema de poleas).

## Sistema de poleas

En el repositorio podrá encontrar los archivos necesarios para imprimir en 3D el sistema de poleas. El mismo consiste en 2 partes que deben adherirse mediante cemento de contacto u otro pegamento adecuado para ABS. Antes, deberá adherir una de las coronas del rodamiento axial (la de mayor diámetro interno) al soporte y luego pegar las poleas al mismo. En la figura 2 puede verse el sistema de poleas armado y el rodamiento axial montado sobre el eje (tornillo de 10mm).

![Fig 1](https://github.com/pcremades/Rotaciones/raw/master/Documentaci%C3%B3n/figs/fig2.png)
*Fig 2. Foto del sistema de rotaciones completo.*

Por la parte inferior del sistema de poleas, debe pegar la zebra para el sistema de adquisición de datos. En el repositorio podrá encontrar el archivo para imprimir la zebra.

## Sistema de adquisición de datos

El sistema de adquisición de datos consiste en un sensor de luz por reflectancia tipo CNY70, conectado a un Arduino Nano. El sensor puede montarse directamente sobre el Arduino. El detalle sobre cómo conectar el sensor CNY70 puede encontrase [aquí](https://www.minitronica.com/uso-del-sensor-cny70-con-arduino/). Finalmente, la placa se fija sobre la base del sistema de rotaciones, procurando que el sensor quede alineado con la zebra del sistema de poleas.

## Accesorios

Con el MDF restante, cortar un círculo de 30cm de diámetro y otro de 20cm de diámetro con un orificio en el centro de 2,2cm. Se recomienda utilizar una cortadora láser para esta tarea. Estos discos se colocarán sobre el soporte para estudiar cinemática y dinámica de las rotaciones de estos cuerpos.
