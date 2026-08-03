function f = lorenz_ext_base(t, X)
%
%  Lorenz equation - Caso BASE (parametros classicos de Lorenz, 1963)
%
%               dx/dt = SIGMA*(y - x)
%               dy/dt = R*x - y - x*z
%               dz/dt = x*y - BETA*z
%
%        SIGMA = 10, R = 28, BETA = 8/3
%        Initial conditions: x(0) = 0, y(0) = 1, z(0) = 0
%        Valores de referencia da literatura (t=10000):
%              L_1 = 0.9022, L_2 = 0.0003, L_3 = -14.5691
%        (K. Ramasubramanian, M.S. Sriram, Physica D 139 (2000) 72-86)
%
% Baseado em: Copyright (C) 2004, Govorukhin V.N.
SIGMA = 10;
R = 28;
BETA = 8/3;
x = X(1); y = X(2); z = X(3);
Y = [X(4), X(7), X(10);
     X(5), X(8), X(11);
     X(6), X(9), X(12)];
f = zeros(9,1);
% Lorenz equation
f(1) = SIGMA*(y - x);
f(2) = -x*z + R*x - y;
f(3) = x*y - BETA*z;
% Linearized system
Jac = [-SIGMA, SIGMA,    0;
         R-z,    -1,   -x;
           y,     x, -BETA];
% Variational equation
f(4:12) = Jac*Y;
end
