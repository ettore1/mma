function yprime = system_nao_linear_periodico_mod(t, y)
% MODIFICACAO: Reducao da frequencia de excitacao (w)
% w: 0.8 -> 0.45 (proximo do limite inferior da faixa indicada no
% script original: 0.4 a 0.9)
yprime = zeros(3,1);
% ========================== Parametros Realimentados ===================
c =  0.01;
x =  0.05;
k =  0.5;
l =  0.05;
f =  0.083; % Fixo
w =  0.45;  % MODIFICADO (era 0.8)
% ============================= State Space ========================
yprime(1) = y(2);
yprime(2) = (1/2)*y(1)*(1 - y(1)^2) - 2*c*y(2) + x*y(3) + f*cos(w*t);
yprime(3) = -k*y(2) - l*y(3);
%==================================================================
end
