function run_aula1()
% Driver - Trabalho 1 (Sistemas Caoticos)
% Executa o caso BASE e as 3 modificacoes do Modelo Linear com Excitacao
% Periodica, gera os graficos e salva tudo em um unico PDF
% (figuras/aula1_graficos.pdf), alem de um resumo numerico em
% relatorio/resultados_aula1.txt

close all;
scriptDir = fileparts(mfilename('fullpath'));
figDir = fullfile(scriptDir, '..', 'figuras');
outDir = fullfile(scriptDir, '..', 'relatorio');
if ~exist(figDir,'dir'); mkdir(figDir); end
if ~exist(outDir,'dir'); mkdir(outDir); end

pdfFile = fullfile(figDir, 'aula1_graficos.pdf');
if exist(pdfFile, 'file'); delete(pdfFile); end

logFile = fullfile(outDir, 'resultados_aula1.txt');
flog = fopen(logFile, 'w');

casos = struct('nome', {}, 'fun', {}, 'desc', {});
casos(1).nome = 'BASE';
casos(1).fun  = @system_linear_periodico;
casos(1).desc = 'zeta=0.01, Omega=0.8, f=0.083 (parametros originais - Erturk e Inman, 2011)';
casos(2).nome = 'MOD1';
casos(2).fun  = @system_linear_periodico_mod1;
casos(2).desc = 'zeta: 0.01 -> 0.15 (aumento do amortecimento mecanico)';
casos(3).nome = 'MOD2';
casos(3).fun  = @system_linear_periodico_mod2;
casos(3).desc = 'Omega: 0.8 -> 0.7071 = sqrt(1/2) (excitacao na frequencia natural / ressonancia)';
casos(4).nome = 'MOD3';
casos(4).fun  = @system_linear_periodico_mod3;
casos(4).desc = 'f: 0.083 -> 0.40 (aumento da amplitude da excitacao de base)';

tspan = 0:0.1:2500;
y0 = [1 0 0];

for i = 1:numel(casos)
    [t, y] = ode45(casos(i).fun, tspan, y0);
    desl = y(:,1);
    vel  = y(:,2);
    tens = y(:,3);
    pot  = (rms(tens))^2/0.1;
    idxReg = (numel(t)-5000):numel(t);

    fprintf('Caso %s: %s | Potencia = %.6e\n', casos(i).nome, casos(i).desc, pot);
    fprintf(flog, 'Caso %s: %s\n  Potencia media = %.6e (u.a.)\n  Amplitude max |deslocamento| (regime) = %.4f\n  Amplitude max |tensao| (regime) = %.4f\n\n', ...
        casos(i).nome, casos(i).desc, pot, max(abs(desl(idxReg))), max(abs(tens(idxReg))));

    % --- Figura 1: Deslocamento ---
    fig = figure('Visible','off');
    plot(t, desl, 'k'); xlabel('Tempo [amostra]','fontsize',14);
    ylabel('Deslocamento [taxa]','fontsize',14);
    title(sprintf('%s - Deslocamento da ponta da viga', casos(i).nome));
    exportgraphics(fig, pdfFile, 'Append', true); close(fig);

    % --- Figura 2: Velocidade ---
    fig = figure('Visible','off');
    plot(t, vel, 'k'); xlabel('Tempo [amostra]','fontsize',14);
    ylabel('Velocidade [taxa]','fontsize',14);
    title(sprintf('%s - Velocidade da ponta da viga', casos(i).nome));
    exportgraphics(fig, pdfFile, 'Append', true); close(fig);

    % --- Figura 3: Tensao ---
    fig = figure('Visible','off');
    plot(t, tens, 'k'); xlabel('Tempo [amostra]','fontsize',14);
    ylabel('Tensao eletrica [taxa]','fontsize',14);
    title(sprintf('%s - Tensao captada (Potencia = %.4e)', casos(i).nome, pot));
    exportgraphics(fig, pdfFile, 'Append', true); close(fig);

    % --- Figura 4: retrato de fase 3D ---
    fig = figure('Visible','off');
    plot3(t, desl, vel, 'k'); grid on;
    xlabel('Tempo [amostra]','fontsize',12);
    ylabel('Deslocamento [taxa]','fontsize',12);
    zlabel('Velocidade [taxa]','fontsize',12);
    title(sprintf('%s - Retrato de fase 3D', casos(i).nome));
    exportgraphics(fig, pdfFile, 'Append', true); close(fig);

    % --- Figura 5: retrato de fase 2D (regime permanente) ---
    fig = figure('Visible','off');
    plot(desl(idxReg), vel(idxReg), 'k');
    xlabel('Deslocamento [taxa]','fontsize',14);
    ylabel('Velocidade [taxa]','fontsize',14);
    title(sprintf('%s - Retrato de fase (regime permanente)', casos(i).nome));
    exportgraphics(fig, pdfFile, 'Append', true); close(fig);
end

fclose(flog);
fprintf('\nPDF de graficos salvo em: %s\n', pdfFile);
fprintf('Resumo numerico salvo em: %s\n', logFile);
end
