function f = lorenz_ext_caseB(t, X)
%
%  Lorenz equation - CASO B (Trabalho 3)
%
%        SIGMA = 16, R (rho) = 45, BETA = 4
%        Expoentes de Lyapunov esperados (literatura da disciplina):
%              L_1 ~= 1.102, L_2 ~= 0, L_3 ~= -20.55
%
% Baseado em: Copyright (C) 2004, Govorukhin V.N.
SIGMA = 16;
R = 45;
BETA = 4;
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
