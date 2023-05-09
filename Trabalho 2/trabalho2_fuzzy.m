%{
Universidade Federal de Pelotas

Disciplina: Inteligencia Artificial
Professor: Elmer A. G. Penaloza

Trabalho 2 - Logica Fuzzy
Diagnostico de cancer de mama
%}

%{
Dados do banco

1) ID number
2) Diagnosis (M = malignant, B = benign)
3-32)
Ten real-valued features are computed for each cell nucleus:

a) radius (mean of distances from center to points on the perimeter)
b) texture (standard deviation of gray-scale values)
c) perimeter
d) area
e) smoothness (local variation in radius lengths)
f) compactness (perimeter^2 / area - 1.0)
g) concavity (severity of concave portions of the contour)
h) concave points (number of concave portions of the contour)
i) symmetry
j) fractal dimension ("coastline approximation" - 1)

LINK: https://archive.ics.uci.edu/ml/datasets/Breast+Cancer+Wisconsin+%28Diagnostic%29
%}


clc, close all, clear all


dados = readtable('data.csv');

area = dados.Var6;
perimetro = dados.Var5;
uniformidade = dados.Var23 - dados.Var3; % diferenca entre o raio extremo e medio
homogeniedade = dados.Var31 - dados.Var11; % diferenca entre o valor da simetria extremo e medio
diagnostico = dados.Var2;

% Fuzzy Inference System
% Mamdani
fis = newfis('trabalho2IA');

fis = addvar(fis, 'input', 'area', [0 2501]);
% Funcoes de pertinencia entrada 1 (area)
fis = addmf(fis, 'input', 1, 'menor', 'trapmf', [0, 0, 748.8, 1000]);
fis = addmf(fis, 'input', 1, 'maior', 'trapmf', [508.1, 2194, 2501, 2501]);

figure(1)
plotmf(fis, 'input', 1)

fis = addvar(fis, 'input', 'perimetro', [0 188.5]);
% Funcoes de pertinencia entrada 2 (perimetro)
fis = addmf(fis, 'input', 2, 'menor', 'trapmf', [0, 0, 92.58, 103]);
fis = addmf(fis, 'input', 2, 'maior', 'trapmf', [85.1, 159.8, 188.5, 188.5]);

figure(2)
plotmf(fis, 'input', 2)

fis = addvar(fis, 'input', 'uniformidade', [0 11.76]);
% Funcoes de pertinencia entrada 3 (uniformidade)
fis = addmf(fis, 'input', 3, 'menor', 'trapmf', [0, 0, 1.669, 2.6]);
fis = addmf(fis, 'input', 3, 'maior', 'trapmf', [0.65, 6.205, 11.76, 11.76]);

figure(3)
plotmf(fis, 'input', 3)

fis = addvar(fis, 'input', 'homogeneidade', [0 0.4041]);
% Funcoes de pertinencia entrada 4 (homogeneidade)
fis = addmf(fis, 'input', 4, 'menor', 'trapmf', [0, 0, 0.1232, 0.19]);
fis = addmf(fis, 'input', 4, 'maior', 'trapmf', [0.0295, 0.2168, 0.4041, 0.4041]);

figure(4)
plotmf(fis, 'input', 4)

fis = addvar(fis, 'output', 'diagnostico', [0 1]);
% Funcoes de pertinencia saida 1 (diagnostico)
fis = addmf(fis, 'output', 1, 'benigno', 'trimf', [0 0 1]);
fis = addmf(fis, 'output', 1, 'maligno', 'trimf', [0 1 1]);

figure(5)
plotmf(fis, 'output', 1)


% Adiconando regras
% listaRegras = [Mfi1 Mfi2 Mfo1 Peso Operador]
% listaRegras = [entradas saidas peso operador]
% Peso geralmente é deixado como 1
% Operador Fuzzy AND/OR -> 1 = AND, 2 = OR
% Cada linha representa uma regra
listaRegras = [
    1 1 1 1 1 1 1; % Se a area, perimetro, uniformidade e homogeniedade forem menor -> benigno
    2 2 2 2 2 1 1; % Se a area, perimetro, uniformidade e homogeniedade forem maior -> maligno
    ];

fis = addrule(fis, listaRegras);

celula_resultados = cell(height(dados), 1);
acertos = 0;
for i = 1:1:height(dados)
    resultado = evalfis([area(i) perimetro(i) uniformidade(i) homogeniedade(i)], fis);
    
    if resultado > 0.5
       celula_resultados{i} = 'M';
    else
       celula_resultados{i} = 'B'; 
    end
    
    
    % Comparando os resultados
    if isequal(diagnostico(i), celula_resultados(i))
        acertos = acertos + 1;
    end
end

figure(6)
plotfis(fis)

figure(7)
gensurf(fis)

acertos
precisao_pct = (acertos / height(dados)) * 100

%close all
