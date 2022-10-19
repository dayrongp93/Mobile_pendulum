function phiprime = movependulum(t,phi,masas,l)
% Esta funci�n contiene las ecuaciones para el estudio del movimiento del
% p�ndulo m�vil.

m1 = masas(1); % Masa del cuerpo 1
m2 = masas(2); % Masa del cuerpo suspendido
g = 9.8; % Aceleraci�n de la gravedad

F = @(g,l,m1,m2,phi1,phi2) (-1/(m1+m2*l*sin(phi1)^2))*((m2/2)*l*sin(2*phi1)*phi2^2+(m1+m2)*g*sin(phi1));
% Se define entonces el sistema para la ecuaci�n de segundo orden
phiprime = [phi(2);F(g,l,m1,m2,phi(1),phi(2))];
