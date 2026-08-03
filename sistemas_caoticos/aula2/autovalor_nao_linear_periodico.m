
% Estabilidade do Sistema

% Est�vel: Se todos os autovalores t�m partes reais negativas, o sistema retorna ao equil�brio ap�s uma perturba��o.
% Inst�vel: Se pelo menos um autovalor tem uma parte real positiva, o sistema tende a divergir do equil�brio.
% Marginalmente Est�vel: Se os autovalores t�m partes reais zero ou negativas, mas n�o todos s�o estritamente negativos, o sistema pode oscilar indefinidamente sem convergir ou divergir1.


% C�lculo de Autovalores
clear all
clc 
format short

%Par�metros
c=	 0.01;
x=	 0.05;
k=	 0.5;
l=	 0.05;
f=	 0.5;
w =  0.083;
t =  1;

%Jabobiano (Lineariza��o)
syms y1 y2 y3;
f1= y2;
f2= (1/2)*y1*(1-y1^2)-2*c*y2+x*y3+f*cos(w*t);
f3= -k*y2-l*y3;
J = jacobian([f1; f2; f3], [y1 y2 y3]);

%Valores para lineariza��o
y1=1;
y2=1;
y3=1;

%Autovalores
A=subs (J); A=double(A)
autovalor=eig(A)
