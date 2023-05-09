%{
Universidade Federal de Pelotas

Disciplina: Inteligencia Artificial
Professor: Elmer A. G. Penaloza

Trabalho 2 - TESTES
%}


clc, close all, clear all

dados = readtable('data.csv');

area = dados.Var6;
perimetro = dados.Var5;
uniformidade = dados.Var23 - dados.Var3; % diferenca entre o raio extremo e medio
homogeniedade = dados.Var31 - dados.Var11; % diferenca entre o valor da simetria extremo e medio
diagnostico = dados.Var2;
 
 