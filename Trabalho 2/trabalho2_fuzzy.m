%{
Universidade Federal de Pelotas

Disciplina: Inteligencia Artificial
Professor: Elmer A. G. Penaloza

Trabalho 2 - Logica Fuzzy
%}


clc, close all, clear all


% Fuzzy Inference System
% Mamdani
fis = newfis('trabalho2IA');

fis = addvar(fis, 'input', 'servico', [0 10]);
% Funcoes de pertinencia entrada 1 (servico)
fis = addmf(fis, 'input', 1, 'ruim', 'gaussmf', [1.5 0]);
fis = addmf(fis, 'input', 1, 'bom', 'gaussmf', [1.5 5]);
fis = addmf(fis, 'input', 1, 'excelente', 'gaussmf', [1.5 10]);

figure(1)
plotmf(fis, 'input', 1)

fis = addvar(fis, 'input', 'comida', [0 10]);
% Funcoes de pertinencia entrada 2 (comida)
fis = addmf(fis, 'input', 2, 'rancosa', 'trapmf', [0 0 1 3]);
fis = addmf(fis, 'input', 2, 'deliciosa', 'trapmf', [7 9 10 inf]);

figure(2)
plotmf(fis, 'input', 2)

fis = addvar(fis, 'output', 'gorjeta', [0 30]);
% Funcoes de pertinencia saida 1 (porcentagem de gorjeta)
fis = addmf(fis, 'output', 1, 'baixa', 'trimf', [0 5 10]);
fis = addmf(fis, 'output', 1, 'media', 'trimf', [10 15 20]);
fis = addmf(fis, 'output', 1, 'generosa', 'trimf', [20 25 30]);

% Adiconando regras
% listaRegras = [Mfi1 Mfi2 Mfo1 Peso Operador]
% listaRegras = [entradas saidas peso operador]
% Peso geralmente � deixado como 1
% Operador Fuzzy AND/OR -> 1 = AND, 2 = OR
% Cada linha representa uma regra
listaRegras = [
    1 1 1 1 2; % Se o servico eh ruim ou a comida eh rancosa, ent�o a gorjeta e baixa
    2 0 2 1 2; % Se o servico eh bom, ent�o a gorjeta e media
    3 2 3 1 2  % Se o servico eh excelente ou a comida eh deliciosa, ent�o a gorjeta e generosa
    ];

fis = addrule(fis, listaRegras);

entradas = [3 5; 2 7; 4 2];

gorjetas = evalfis([3 8], fis)

entradas = evalfis(entradas, fis)

figure(3)
gensurf(fis)