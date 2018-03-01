clear all
%Leemos los datos del archivo y los guardamos en una matriz.
Datos = dlmread("./salida3.txt");
%Guardamos la primer columna, que tiene el tiempo en milisegundos
%en un vetor.
tiempo = Datos(:,1)/1000;
%Guardamos la segunda columna que tiene la posicion en "pasos".
ps = Datos(:,2);

%Convertimos Pasos a angulo en grados
DiamSmall = 2.2;
DiamBig = 83.0;
Ratio = DiamBig/DiamSmall;
Ranuras = 90;   %Raturas y espacios tapados. Raunuras solas son 45
ThetaPs = 360/Ranuras/Ratio;
ps = ps .* ThetaPs;

%Generamos un vector (kernel) para calcular la tendencia de la señal
%mediante la convolucion.
kern = hamming(151);
kern = kern / sum(kern);  %Normalizamos el kernel.

%Calculamos la tendencia de la señal.
psTend = conv(ps, kern, "same");

%Restamos la tendencia de la señal.
psNew = ps - psTend;

%Graficamos la señal en el tiempo.
figure(1)
plot(tiempo, psNew)

%Algortimo para buscar los maximos y los minimos de la señal
mx = -1000;
mn = 1000;
delta = 10*ThetaPs;
lookformax = 1;
mxpos = 0; mnpos = 0;
maxList=[]; %Lista de valores maximos
minList=[]; %Lista de valores minimos
maxPos=[];  %Posicion de los valores maximos
minPost=[]; %Posicion de los valores minimos
for i=125:numel(tiempo) %Descartamos los primeros valores.
  this = psNew(i);
  if this > mx, mx = this; mxpos = i; end
  if this < mn, mn = this; mnpos = i; end
  
  if lookformax
    if this < mx-delta
      mn = this; mnpos = i;
      lookformax = 0;
      maxList = [maxList; mx];
      maxPos = [maxPos; tiempo(i)];
    end  
  else
    if this > mn+delta
      mx = this; mxpos = i;
      lookformax = 1;
      minList = [minList; mn];
      minPos = [mnpos; tiempo(i)];
    end
  end
endfor

%Graficamos los valores maximos
hold on
plot(maxPos, maxList, "*r")
axTime = gca();
set(axTime, "xlabel", "tiempo [s]")
set(axTime, "xtick", [0:10:max(tiempo)]);
set(axTime, "ylabel", "angulo [deg]")
legend("Posicion", "Maximos")
hold off
set(gca, "fontsize", 12);
%print -dpdf "Figura1.pdf"
%print -dsvg "Figura1.png"

%Interpolacion de picos
newTime = min(maxPos):1:max(maxPos);
YI = interp1(maxPos, maxList, newTime);

%Buscamos la envolvente para calcular el coeficiente de amortiguamiento
%[alpha,c,rms] = expfit(1, newTime(1), 1, YI) %Ajuste exponencial
%Calculamos Tau
%Tau = (-1/alpha)  %Tau en segundos +log(c)

Coef = polyfit(newTime, YI, 1)
alpha = Coef(1);

figure(2)
plot(maxPos, maxList, "*")
axFit = gca();
set(axFit, "fontname", "DejaVuSans");

hold on
%envolvente = c * exp(alpha*newTime);
envolvente = Coef(2) + Coef(1)*newTime;
plot(newTime, envolvente, "-r");
xlabel("tiempo [s]")
ylabel("amplitud")
axTXT=text(newTime(numel(newTime)/2), max(envolvente)*0.9, "k = ");
set(axTXT, "fontsize", 12 )
axTXT=text(newTime(numel(newTime)/2) + 5, max(envolvente)*0.9, num2str(round(alpha*1000)/1000));
set(axTXT, "fontsize", 12 )
%axTXT=text(newTime(numel(newTime)/2), max(envolvente)*0.8, "Tau [s] = ");
set(axTXT, "fontsize", 12 )
%axTXT=text(newTime(numel(newTime)/2) + 14, max(envolvente)*0.8, num2str(round(Tau*100)/100));
set(axTXT, "fontsize", 12 )
legend("Maximos", "Envolvente");
hold off
print -dpdf "Figura2d.pdf"

%Analisis de Fourier
newTime = min(tiempo):1/1000:max(tiempo);
YII = interp1(tiempo, psNew, newTime);

t_sample = 1/1000; %En segundos
FS = 1/t_sample;
Fmax = FS/2;
FFT = abs(fft(YII));
df = Fmax/(numel(FFT)/2);
f=0:df:Fmax;
figure(3)
plot(f(1:140), FFT(1:140))
axFFT = gca();
set(axFFT, "fontname", "DejaVuSans");
xlabel("f [Hz]")
ylabel("|FFT|")
MaxFFT = find(FFT==max(FFT));
text(f(MaxFFT(1)), FFT(MaxFFT(1)), num2str(f(MaxFFT(1))))
%print -dpdf "Figura3.pdf"
%set(gca,"xlim",[0:100])
%plot(psTend)

