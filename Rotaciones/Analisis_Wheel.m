clear all
A=dlmread("./datos_M1.txt");
B=dlmread("./datos_M2.txt");
timeA = (A(:,1) - min(A(:,1)))/1000;
psA = A(:,2);
wsA = A(:,3)*2;
timeB = (B(:,1) - min(B(:,1)))/1000;
psB = B(:,2);
wsB = B(:,3)*2;

newTimeA = min(timeA):0.1:max(timeA);
newTimeB = min(timeB):0.1:max(timeB);

wsAIntrp = interp1(timeA, wsA, newTimeA);
wsBIntrp = interp1(timeB, wsB, newTimeB);


kern = hamming(51);
kern = kern/sum(kern);

%ws = diff(ps)./diff(time);
wsAFilter=conv(wsAIntrp, kern, "same");
wsBFilter=conv(wsBIntrp, kern, "same");

asA = diff(wsAFilter)./diff(newTimeA);
asB = diff(wsBFilter)./diff(newTimeB);

maxWsA = find(wsAFilter == max(wsAFilter))(1);
maxWsB = find(wsBFilter == max(wsBFilter))(1);

figure(1)
plot( newTimeA(1:end), wsAFilter, "-");
hold on
plot( newTimeB(1:end), wsBFilter, "r-");
axTXT = text( newTimeA(maxWsA), wsAFilter(maxWsA)*1.1, num2str( round(100*wsAFilter(maxWsA))/100) );
set(axTXT, "fontsize", 12 )
axTXT = text( newTimeB(maxWsB), wsBFilter(maxWsB)*1.05, num2str( round(100*wsBFilter(maxWsB))/100) );
set(axTXT, "fontsize", 12 )
set(gca, "fontsize", 12);
set(gca, "xlabel", "tiempo [s]", "fontsize", 12)
set(gca, "ylabel", "ws [rad/s]", "fontsize", 12)
legend("ws para M1 = 7g", "ws para M2 = 25g")
hold off
print -dpdf "Figura1.pdf"

%Buscamos la envolvente para calcular el coeficiente de amortiguamiento
newWSA = wsAFilter(maxWsA:end);
newWSB = wsBFilter(maxWsB:end);
[alphaA,cA] = polyfit(newTimeA(maxWsA:end), newWSA, 1);
figure(2)
plot(newTimeA(maxWsA:end), newWSA, "*")
hold
plot(newTimeA(maxWsA:end), alphaA(2) + alphaA(1)*newTimeA(maxWsA:end), "-r")
legend("Velocidad angular", "Regresion lineal");
axTXT = text( max(newTimeA)/2 - 3, max(newWSA)/2, "Alpha = " );
set(axTXT, "fontsize", 12 )
axTXT = text( max(newTimeA)/2, max(newWSA)/2, num2str(round(alphaA(1)*1000)/1000) );
set(axTXT, "fontsize", 12 )
set(gca, "xlabel", "tiempo [s]", "fontsize", 12)
set(gca, "ylabel", "ws [rad/s]", "fontsize", 12)
hold off
print -dpdf "Figura2.pdf"

[alphaB,cB] = polyfit(newTimeB(maxWsB:end), newWSB, 1);
figure(3)
plot(newTimeB(maxWsB:end), newWSB, "*")
hold
plot(newTimeB(maxWsB:end), alphaB(2) + alphaB(1)*newTimeB(maxWsB:end), "-r")
legend("Velocidad angular", "Regresion lineal");
axTXT = text( max(newTimeB)/2 - 11, max(newWSB)/2, "Alpha = " );
set(axTXT, "fontsize", 12 )
axTXT = text( max(newTimeB)/2 - 7, max(newWSB)/2, num2str(round(alphaB(1)*1000)/1000) );
set(axTXT, "fontsize", 12 )
set(gca, "xlabel", "tiempo [s]", "fontsize", 12)
set(gca, "ylabel", "ws [rad/s]", "fontsize", 12)
hold off
print -dpdf "Figura3.pdf"

%figure(3)
%plot( newTimeA(2:end), asA, "-");
%hold on
%plot( newTimeB(2:end), asB, "r-");
%hold off

