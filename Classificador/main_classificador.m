%MAIN DE CLASSIFICADOR

clear all;
clc;

%-----------------NO TOCAR-----------------
[miMap] = examengdsa();
[tree_output,bbdd_train,m] = entrenament(); %Entrenar
%------------------------------------------


examengdsa2(miMap);
classificador(tree_output,bbdd_train,m);  %Clasificacion
avaluador();
