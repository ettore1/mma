function yprime = system_linear_periodico_mod3(t, y)
% MODIFICACAO 3: Aumento da amplitude da excitacao de base
% f: 0.083 -> 0.40 (vibracao ambiente ~5x mais intensa)
yprime = zeros(3,1);
% ========================== Parametros Realimentados ===================
c =  0.01;  % zeta
x =  0.05;  % chi
k =  0.5;   % kappa
l =  0.05;  % Lambda
f =  0.40;  % f - AUMENTADO (era 0.083)
w =  0.8;   % Omega
% ============================= State Space ==============================
yprime(1) = y(2);
yprime(2) = (-1/2)*y(1) - 2*c*y(2) + x*y(3) + f*cos(w*t);
yprime(3) = -k*y(2) - l*y(3);
% =========================================================================
end
