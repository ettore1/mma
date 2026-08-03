function yprime = system_linear_periodico_mod2(t, y)
% MODIFICACAO 2: Frequencia de excitacao proxima da ressonancia
% Frequencia natural do sistema linearizado: wn = sqrt(1/2) = 0.7071 rad/amostra
% Omega: 0.8 -> 0.7071 (excitacao sintonizada em wn, ressonancia)
yprime = zeros(3,1);
% ========================== Parametros Realimentados ===================
c =  0.01;    % zeta
x =  0.05;    % chi
k =  0.5;     % kappa
l =  0.05;    % Lambda
f =  0.083;   % f
w =  sqrt(1/2); % Omega - AJUSTADO para a frequencia natural (era 0.8)
% ============================= State Space ==============================
yprime(1) = y(2);
yprime(2) = (-1/2)*y(1) - 2*c*y(2) + x*y(3) + f*cos(w*t);
yprime(3) = -k*y(2) - l*y(3);
% =========================================================================
end
