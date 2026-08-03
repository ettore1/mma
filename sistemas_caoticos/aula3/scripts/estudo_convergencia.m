% Estudo de convergencia dos expoentes de Lyapunov (Casos A e B)
% em funcao do passo de renormalizacao (stept) e do tempo total de
% simulacao (tend), conforme solicitado no enunciado do Trabalho 3
% ("alem dos parametros, devem ser variados o stept e tend").
clear all; clc;

ystart = [0 1 0];

combinacoes = [0.5, 5000;
               0.5, 10000;
               0.5, 20000;
               0.1, 5000;
               0.05, 5000];

fprintf('======= CASO A (sigma=14, rho=35, beta=5/3) =======\n');
fprintf('  stept |   tend  |    L1     |    L2     |    L3\n');
for i = 1:size(combinacoes,1)
    stept = combinacoes(i,1); tend = combinacoes(i,2);
    [~, Lexp] = lyapunov_matds(3, @lorenz_ext_caseA, @ode45, 0, stept, tend, ystart, 0);
    L = Lexp(end,:);
    fprintf('  %5.2f | %6.0f  | %9.6f | %9.6f | %9.6f\n', stept, tend, L(1), L(2), L(3));
end

fprintf('\n======= CASO B (sigma=16, rho=45, beta=4) =======\n');
fprintf('  stept |   tend  |    L1     |    L2     |    L3\n');
for i = 1:size(combinacoes,1)
    stept = combinacoes(i,1); tend = combinacoes(i,2);
    [~, Lexp] = lyapunov_matds(3, @lorenz_ext_caseB, @ode45, 0, stept, tend, ystart, 0);
    L = Lexp(end,:);
    fprintf('  %5.2f | %6.0f  | %9.6f | %9.6f | %9.6f\n', stept, tend, L(1), L(2), L(3));
end
