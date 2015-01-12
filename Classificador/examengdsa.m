function [miMap]=examengdsa()
%-------------LO LLEVAMOS HECHO DE CASA------------------------------------
%Cargamos el .mat con id y vector
tic;
display('Cargando fichero .mat');
load('bofs_256_10_examen_test.mat'); %Formar map con todos los descriptores de todas las fotos de desenvolupament

%Creamos el map
miMap = containers.Map();

l=length(fieldnames(bofs(1)));

display('Llenando el map');
%Llenamos el map del .mat con id - vector
for j=1:l
    nombre=fieldnames(bofs(1));
    nombre(j);
    vector= getfield(bofs(1),nombre{j});
    miMap(nombre{j}) = vector; 
end
toc;

%save('prueba.mat','miMap');


