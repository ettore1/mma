function run_aula2()
% Driver - Trabalho 2 (Sistemas Caoticos)
% Executa o caso BASE e a modificacao (MOD) de cada um dos 3 sistemas de
% EDOs apresentados na Aula 05 (linear_nao_ideal, nao_linear_nao_ideal,
% nao_linear_periodico), gera os graficos e salva tudo em um unico PDF
% (figuras/aula2_graficos.pdf), alem de um resumo numerico em
% relatorio/resultados_aula2.txt

close all;
scriptDir = fileparts(mfilename('fullpath'));
figDir = fullfile(scriptDir, '..', 'figuras');
outDir = fullfile(scriptDir, '..', 'relatorio');
if ~exist(figDir,'dir'); mkdir(figDir); end
if ~exist(outDir,'dir'); mkdir(outDir); end

pdfFile = fullfile(figDir, 'aula2_graficos.pdf');
if exist(pdfFile, 'file'); delete(pdfFile); end

logFile = fullfile(outDir, 'resultados_aula2.txt');
flog = fopen(logFile, 'w');

tspan = 0:0.1:2500;

sistemas = struct('titulo', {}, 'baseFun', {}, 'modFun', {}, 'y0', {}, 'descMod', {});

sistemas(1).titulo  = 'Sistema 1: Linear com Excitacao Nao-Ideal';
sistemas(1).baseFun = @system_linear_nao_ideal;
sistemas(1).modFun  = @system_linear_nao_ideal_mod;
sistemas(1).y0      = [1 0 0 0 0];
sistemas(1).descMod = 'Parametro de controle do motor CC: a = 0.8 -> 3.0';

sistemas(2).titulo  = 'Sistema 2: Nao-Linear com Excitacao Nao-Ideal';
sistemas(2).baseFun = @system_nao_linear_nao_ideal;
sistemas(2).modFun  = @system_nao_linear_nao_ideal_mod;
sistemas(2).y0      = [1 0 0 0 0];
sistemas(2).descMod = 'Parametro de controle do motor CC: a = 4.0 -> 1.0';

sistemas(3).titulo  = 'Sistema 3: Nao-Linear com Excitacao Periodica';
sistemas(3).baseFun = @system_nao_linear_periodico;
sistemas(3).modFun  = @system_nao_linear_periodico_mod;
sistemas(3).y0      = [1 0 0];
sistemas(3).descMod = 'Frequencia de excitacao: w = 0.8 -> 0.45';

for s = 1:numel(sistemas)
    fprintf(flog, '=== %s ===\n', sistemas(s).titulo);
    fprintf(flog, 'Modificacao: %s\n\n', sistemas(s).descMod);
    fprintf('\n=== %s ===\n', sistemas(s).titulo);

    casos = struct('nome', {'BASE','MOD'}, ...
                    'fun',  {sistemas(s).baseFun, sistemas(s).modFun});

    for c = 1:numel(casos)
        [t, z] = ode45(casos(c).fun, tspan, sistemas(s).y0);
        desl = z(:,1);
        vel  = z(:,2);
        tens = z(:,end); % ultima coluna = tensao eletrica em todos os sistemas
        pot  = (rms(tens))^2/0.1;
        idxReg = (numel(t)-5000):numel(t);

        fprintf('  Caso %s | Potencia = %.6e | max|desl| regime = %.4f | max|tensao| regime = %.4f\n', ...
            casos(c).nome, pot, max(abs(desl(idxReg))), max(abs(tens(idxReg))));
        fprintf(flog, '  Caso %s:\n    Potencia media = %.6e (u.a.)\n    Amplitude max |deslocamento| (regime) = %.4f\n    Amplitude max |tensao| (regime) = %.4f\n\n', ...
            casos(c).nome, pot, max(abs(desl(idxReg))), max(abs(tens(idxReg))));

        tag = sprintf('%s - %s', sistemas(s).titulo, casos(c).nome);

        % --- Figura 1: Deslocamento ---
        fig = figure('Visible','off');
        plot(t, desl, 'k'); xlabel('Tempo [amostra]','fontsize',14);
        ylabel('Deslocamento [taxa]','fontsize',14);
        title(tag, 'Interpreter','none');
        exportgraphics(fig, pdfFile, 'Append', true); close(fig);

        % --- Figura 2: Velocidade ---
        fig = figure('Visible','off');
        plot(t, vel, 'k'); xlabel('Tempo [amostra]','fontsize',14);
        ylabel('Velocidade [taxa]','fontsize',14);
        title(tag, 'Interpreter','none');
        exportgraphics(fig, pdfFile, 'Append', true); close(fig);

        % --- Figura 3: Tensao ---
        fig = figure('Visible','off');
        plot(t, tens, 'k'); xlabel('Tempo [amostra]','fontsize',14);
        ylabel('Tensao eletrica [taxa]','fontsize',14);
        title(sprintf('%s (Potencia = %.4e)', tag, pot), 'Interpreter','none');
        exportgraphics(fig, pdfFile, 'Append', true); close(fig);

        % --- Figura 4: retrato de fase 3D ---
        fig = figure('Visible','off');
        plot3(t, desl, vel, 'k'); grid on;
        xlabel('Tempo [amostra]','fontsize',12);
        ylabel('Deslocamento [taxa]','fontsize',12);
        zlabel('Velocidade [taxa]','fontsize',12);
        title(tag, 'Interpreter','none');
        exportgraphics(fig, pdfFile, 'Append', true); close(fig);

        % --- Figura 5: retrato de fase 2D (regime permanente) ---
        fig = figure('Visible','off');
        plot(desl(idxReg), vel(idxReg), 'k');
        xlabel('Deslocamento [taxa]','fontsize',14);
        ylabel('Velocidade [taxa]','fontsize',14);
        title(tag, 'Interpreter','none');
        exportgraphics(fig, pdfFile, 'Append', true); close(fig);
    end
    fprintf(flog, '\n');
end

fclose(flog);
fprintf('\nPDF de graficos salvo em: %s\n', pdfFile);
fprintf('Resumo numerico salvo em: %s\n', logFile);
end
