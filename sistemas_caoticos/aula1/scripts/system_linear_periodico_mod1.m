function yprime = system_linear_periodico_mod1(t, y)
% MODIFICACAO 1: Aumento do amortecimento mecanico (zeta)
% zeta: 0.01 -> 0.15  (amortecedor mecanico 15x mais forte)
yprime = zeros(3,1);
% ========================== Parametros Realimentados ===================
c =  0.15;  % zeta   - AUMENTADO (era 0.01)
x =  0.05;  % chi
k =  0.5;   % kappa
l =  0.05;  % Lambda
f =  0.083; % f
w =  0.8;   % Omega
% ============================= State Space ==============================
yprime(1) = y(2);
yprime(2) = (-1/2)*y(1) - 2*c*y(2) + x*y(3) + f*cos(w*t);
yprime(3) = -k*y(2) - l*y(3);
% =========================================================================
end
