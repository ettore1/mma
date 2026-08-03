function f = lorenz_ext_caseA(t, X)
%
%  Lorenz equation - CASO A (Trabalho 3)
%
%        SIGMA = 14, R (rho) = 35, BETA = 5/3
%        Expoentes de Lyapunov esperados (literatura da disciplina):
%              L_1 ~= 0.996, L_2 ~= 0, L_3 ~= -17.6
%
% Baseado em: Copyright (C) 2004, Govorukhin V.N.
SIGMA = 14;
R = 35;
BETA = 5/3;
x = X(1); y = X(2); z = X(3);
Y = [X(4), X(7), X(10);
     X(5), X(8), X(11);
     X(6), X(9), X(12)];
f = zeros(9,1);
f(1) = SIGMA*(y - x);
f(2) = -x*z + R*x - y;
f(3) = x*y - BETA*z;
Jac = [-SIGMA, SIGMA,    0;
         R-z,    -1,   -x;
           y,     x, -BETA];
f(4:12) = Jac*Y;
end
