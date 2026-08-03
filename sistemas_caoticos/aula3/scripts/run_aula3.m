function run_aula3()
% Driver - Trabalho 3 (Sistemas Caoticos)
% Determina os expoentes de Lyapunov do Oscilador de Lorenz (algoritmo de
% Wolf/Govorukhin, lyapunov_matds.m) para o caso BASE (parametros
% classicos de Lorenz, 1963) e para os Casos A e B propostos no
% Trabalho 3, comparando com os valores de referencia da literatura.
%
% Gera os graficos (dinamica dos expoentes de Lyapunov + atrator/orbitas
% de cada caso) em um unico PDF (figuras/aula3_graficos.pdf) e um resumo
% numerico em relatorio/resultados_aula3.txt

close all;
scriptDir = fileparts(mfilename('fullpath'));
figDir = fullfile(scriptDir, '..', 'figuras');
outDir = fullfile(scriptDir, '..', 'relatorio');
if ~exist(figDir,'dir'); mkdir(figDir); end
if ~exist(outDir,'dir'); mkdir(outDir); end

pdfFile = fullfile(figDir, 'aula3_graficos.pdf');
if exist(pdfFile, 'file'); delete(pdfFile); end

logFile = fullfile(outDir, 'resultados_aula3.txt');
flog = fopen(logFile, 'w');

% ------------------------------------------------------------------
% Configuracao dos casos: [SIGMA, RHO(R), BETA] + funcao estendida
% ------------------------------------------------------------------
casos = struct('nome', {}, 'fun', {}, 'sigma', {}, 'rho', {}, 'beta', {}, ...
                'ref', {}, 'stept', {}, 'tend', {});

casos(1).nome  = 'BASE (Lorenz classico)';
casos(1).fun   = @lorenz_ext_base;
casos(1).sigma = 10; casos(1).rho = 28; casos(1).beta = 8/3;
casos(1).ref   = [0.9022, 0.0003, -14.5691];
casos(1).stept = 0.5; casos(1).tend = 10000;

casos(2).nome  = 'CASO A';
casos(2).fun   = @lorenz_ext_caseA;
casos(2).sigma = 14; casos(2).rho = 35; casos(2).beta = 5/3;
casos(2).ref   = [0.996, 0, -17.6];
casos(2).stept = 0.5; casos(2).tend = 10000;

casos(3).nome  = 'CASO B';
casos(3).fun   = @lorenz_ext_caseB;
casos(3).sigma = 16; casos(3).rho = 45; casos(3).beta = 4;
casos(3).ref   = [1.102, 0, -20.55];
casos(3).stept = 0.5; casos(3).tend = 10000;

ystart = [0 1 0];

for i = 1:numel(casos)
    fprintf('\n=== %s (sigma=%g, rho=%g, beta=%g) ===\n', casos(i).nome, ...
        casos(i).sigma, casos(i).rho, casos(i).beta);
    fprintf(flog, '=== %s (sigma=%g, rho=%g, beta=%g) ===\n', casos(i).nome, ...
        casos(i).sigma, casos(i).rho, casos(i).beta);
    fprintf(flog, 'Parametros do algoritmo: tstart=0, stept=%g, tend=%g, ystart=[0 1 0]\n', ...
        casos(i).stept, casos(i).tend);

    [Texp, Lexp] = lyapunov_matds(3, casos(i).fun, @ode45, 0, casos(i).stept, ...
        casos(i).tend, ystart, 0);

    L = Lexp(end,:);
    ref = casos(i).ref;
    fprintf('  Calculado : L1=%.6f  L2=%.6f  L3=%.6f\n', L(1), L(2), L(3));
    fprintf('  Referencia: L1=%.4f  L2=%.4f  L3=%.4f\n', ref(1), ref(2), ref(3));
    fprintf(flog, '  Expoentes de Lyapunov calculados : L1=%.6f  L2=%.6f  L3=%.6f\n', L(1), L(2), L(3));
    fprintf(flog, '  Expoentes de referencia (literatura/slide): L1=%.4f  L2=%.4f  L3=%.4f\n', ref(1), ref(2), ref(3));
    fprintf(flog, '  Diferenca absoluta: dL1=%.4f  dL2=%.4f  dL3=%.4f\n\n', ...
        abs(L(1)-ref(1)), abs(L(2)-ref(2)), abs(L(3)-ref(3)));

    % --- Figura 1: Dinamica dos expoentes de Lyapunov no tempo ---
    fig = figure('Visible','off');
    plot(Texp, Lexp, 'LineWidth', 1.0);
    title(sprintf('%s - Dinamica dos Expoentes de Lyapunov', casos(i).nome), 'Interpreter','none');
    xlabel('Tempo'); ylabel('Expoentes de Lyapunov');
    legend('L_1','L_2','L_3','Location','best');
    grid on;
    exportgraphics(fig, pdfFile, 'Append', true); close(fig);

    % --- Trajetoria do sistema de Lorenz (nao-estendido) para o atrator ---
    SIGMA = casos(i).sigma; RHO = casos(i).rho; BETA = casos(i).beta;
    lorenzRHS = @(t,X) [SIGMA*(X(2)-X(1)); RHO*X(1)-X(2)-X(1)*X(3); X(1)*X(2)-BETA*X(3)];
    [t, X] = ode45(lorenzRHS, 0:0.01:100, [0 1 0]);

    % --- Figura 2: Atrator de Lorenz em 3D ---
    fig = figure('Visible','off');
    plot3(X(:,1), X(:,2), X(:,3), 'k', 'LineWidth', 0.5);
    grid on;
    xlabel('x'); ylabel('y'); zlabel('z');
    title(sprintf('%s - Atrator de Lorenz (3D)', casos(i).nome), 'Interpreter','none');
    exportgraphics(fig, pdfFile, 'Append', true); close(fig);

    % --- Figura 3: Projecao x-z ---
    fig = figure('Visible','off');
    plot(X(:,1), X(:,3), 'k', 'LineWidth', 0.5);
    xlabel('x'); ylabel('z');
    title(sprintf('%s - Projecao x-z do atrator', casos(i).nome), 'Interpreter','none');
    exportgraphics(fig, pdfFile, 'Append', true); close(fig);

    % --- Figura 4: Serie temporal de x(t) ---
    fig = figure('Visible','off');
    plot(t, X(:,1), 'k');
    xlabel('Tempo'); ylabel('x(t)');
    title(sprintf('%s - Serie temporal de x(t)', casos(i).nome), 'Interpreter','none');
    exportgraphics(fig, pdfFile, 'Append', true); close(fig);
end

fclose(flog);
fprintf('\nPDF de graficos salvo em: %s\n', pdfFile);
fprintf('Resumo numerico salvo em: %s\n', logFile);
end
