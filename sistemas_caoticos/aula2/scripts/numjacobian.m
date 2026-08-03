function J = numjacobian(fun, t0, y0)
% Jacobiana numerica (diferencas centrais) de fun(t,y) em relacao a y,
% avaliada em (t0, y0). Usada no lugar do Symbolic Math Toolbox
% (Jacobiano simbolico), que nao esta disponivel nesta instalacao do
% MATLAB.
n = numel(y0);
J = zeros(n, n);
h = 1e-6;
for j = 1:n
    yp = y0; yp(j) = yp(j) + h;
    ym = y0; ym(j) = ym(j) - h;
    fp = fun(t0, yp);
    fm = fun(t0, ym);
    J(:, j) = (fp(:) - fm(:)) / (2*h);
end
end
