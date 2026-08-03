function yprime = system_linear_periodico(t, y)
% Modelo Linear com Excitacao Periodica (Erturk e Inman, 2011)
% Captador de energia piezoeletrico - viga em balanco
% Caso BASE, conforme slides da Aula 04 (Analise de Sistemas Caoticos)
yprime = zeros(3,1);
% ========================== Parametros Realimentados ===================
c =  0.01;  % zeta   - fator de amortecimento mecanico
x =  0.05;  % chi    - acoplamento piezoeletrico (eq. mecanica)
k =  0.5;   % kappa  - acoplamento piezoeletrico (eq. eletrica)
l =  0.05;  % Lambda - reciproco da constante de tempo de carga
f =  0.083; % f      - amplitude da forca de aceleracao
w =  0.8;   % Omega  - frequencia de excitacao
% ============================= State Space ==============================
yprime(1) = y(2);
yprime(2) = (-1/2)*y(1) - 2*c*y(2) + x*y(3) + f*cos(w*t);
yprime(3) = -k*y(2) - l*y(3);
% =========================================================================
end
