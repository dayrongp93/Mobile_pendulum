function [t,y] = RK31(F,tspan,y0,h,masas,l)
% Esta funci�n devuelve resuelve un sistema de ecuaciones diferenciales
% utilizando un m�todo de Runge-Kutta de tercer orden RK31
% Este m�todo es conocido como el m�todo de Heun de tercer orden

% Input:
% F = funci�n de miembro derecho de la ecuaci�n diferencial
% h = paso del m�todo
% tspan = [a,b] = intervalo de tiempo de la soluci�n
% y0 = condicion inical

% Output:
% t = partici�n de [a,b]
% y = vector de soluci�n

a = tspan(1); b = tspan(2);
y0 = y0';
t = a;
y = y0;

% Coeficientes del m�todo--------------------
c2 = 2/3;
c3 = 2/3;
a21 = 2/3;
a31 = 1/3;
a32 = 1/3;
b1 = 1/4;
b2 = 0;
b3 = 3/4;
%----------------------------------------------

while a<b
    K1=h*F(a,y0,masas,l);
    K2=h*F(a+c2*h,y0+a21*K1,masas,l);
    K3=h*F(a+c3*h,y0+a31*K1+a32*K2,masas,l);
    
    a = a+h;
    t = [t a];
    y0=y0+(b1*K1+b2*K2+b3*K3);
    y = [y y0];
end