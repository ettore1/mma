% Calculo de Autovalores - Modelo Linear com Excitacao Periodica
% Estabilidade da parte autonoma (linearizacao), casos BASE e MOD 1-3
%
% Como o sistema ja e linear, a matriz Jacobiana e constante e pode ser
% montada diretamente (nao depende do Symbolic Math Toolbox):
%   x1' = x2
%   x2' = -1/2*x1 - 2*c*x2 + x*x3   (+ f*cos(w*t), que nao afeta o Jacobiano)
%   x3' = -k*x2 - l*x3
%
%       [   0      1     0  ]
%   A = [ -1/2   -2c     x  ]
%       [   0     -k    -l  ]
%
% Estavel: todos os autovalores com parte real negativa.
% Instavel: pelo menos um autovalor com parte real positiva.
% Marginalmente estavel: partes reais <= 0, mas nao todas < 0.
clear all
clc
format short

casos = {'BASE', 'MOD1 (zeta alto)', 'MOD2 (ressonancia)', 'MOD3 (f alto)'};
% [c(zeta), x(chi), k(kappa), l(Lambda)]  -- w e f nao entram no Jacobiano
params = [0.01 0.05 0.5 0.05;   % BASE
          0.15 0.05 0.5 0.05;   % MOD1
          0.01 0.05 0.5 0.05;   % MOD2 (mesma matriz A que BASE; muda so Omega)
          0.01 0.05 0.5 0.05];  % MOD3 (mesma matriz A que BASE; muda so f)

for i = 1:size(params,1)
    c = params(i,1); x = params(i,2); k = params(i,3); l = params(i,4);

    A = [   0     1     0;
         -1/2  -2*c     x;
            0    -k    -l];

    autovalor = eig(A);

    fprintf('\n--- Caso %s ---\n', casos{i});
    disp('Matriz A:'); disp(A);
    disp('Autovalores:'); disp(autovalor);
    if all(real(autovalor) < 0)
        fprintf('Classificacao: Sistema ESTAVEL\n');
    elseif any(real(autovalor) > 0)
        fprintf('Classificacao: Sistema INSTAVEL\n');
    else
        fprintf('Classificacao: Sistema MARGINALMENTE ESTAVEL\n');
    end
end
