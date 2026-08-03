% Calculo de Autovalores (estabilidade local) - Trabalho 2
% Sistemas: linear_nao_ideal, nao_linear_nao_ideal, nao_linear_periodico
% BASE e MOD, avaliados no ponto de equilibrio candidato usado como
% condicao inicial de cada simulacao.
%
% A Jacobiana e calculada numericamente (numjacobian.m), pois o
% Symbolic Math Toolbox nao esta disponivel nesta instalacao do MATLAB.
clear all
clc
format short

% --- Sistema 1: linear_nao_ideal ---
y0_5 = [1 0 0 0 0];
J = numjacobian(@system_linear_nao_ideal, 0, y0_5);
classificar('linear_nao_ideal - BASE (a=0.8)', eig(J));
J = numjacobian(@system_linear_nao_ideal_mod, 0, y0_5);
classificar('linear_nao_ideal - MOD (a=3.0)', eig(J));

% --- Sistema 2: nao_linear_nao_ideal ---
J = numjacobian(@system_nao_linear_nao_ideal, 0, y0_5);
classificar('nao_linear_nao_ideal - BASE (a=4.0)', eig(J));
J = numjacobian(@system_nao_linear_nao_ideal_mod, 0, y0_5);
classificar('nao_linear_nao_ideal - MOD (a=1.0)', eig(J));

% --- Sistema 3: nao_linear_periodico ---
y0_3 = [1 0 0];
J = numjacobian(@system_nao_linear_periodico, 0, y0_3);
classificar('nao_linear_periodico - BASE (w=0.8)', eig(J));
J = numjacobian(@system_nao_linear_periodico_mod, 0, y0_3);
classificar('nao_linear_periodico - MOD (w=0.45)', eig(J));

function classificar(nome, autovalor)
    fprintf('\n--- %s ---\n', nome);
    disp('Autovalores:'); disp(autovalor);
    if all(real(autovalor) < 0)
        fprintf('Classificacao: Sistema ESTAVEL\n');
    elseif any(real(autovalor) > 0)
        fprintf('Classificacao: Sistema INSTAVEL\n');
    else
        fprintf('Classificacao: Sistema MARGINALMENTE ESTAVEL\n');
    end
end
