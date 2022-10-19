function [t,y] = RungeK4(F,tspan,y0,h,masas,l)
% Esta funci�n devuelve resuelve un sistema de ecuaciones diferenciales
% utilizando un m�todo de Runge-Kutta de cuarto orden

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

while a<b
    K1=h*F(a,y0,masas,l);
    K2=h*F(a+1/2*h,y0+1/2*K1,masas,l);
    K3=h*F(a+1/2*h,y0+1/2*K2,masas,l);
    K4=h*F(a+h,y0+K3,masas,l);
    
    a = a+h;
    t = [t a];
    y0=y0+1/6*(K1+2*K2+2*K3+K4);
    y = [y y0];
end