%SCRIPT ENTRENAMENT

function [tree_output, bbdd_train,m] = entrenament()
%% -----------------CARREGAR DADES .MAT ENTRENAMENT------------------------
%Primer carreguem el fitxer .mat amb les dades d'entrenament
%format per id_foto,vector_caract i el guardem a la carpeta
%/Imagenes_asignar_clase com a entrenar.txt

tic;
display('Carregant fitxer de train .mat ...');
load('bofs_256_10_examen_train.mat');  
names=fieldnames(bofs(1));
nom = strcat('./Imagenes_asignar_clase', '/','entrenar.txt');
fid=fopen(nom,'wt');

for i=1:length(names)
v=getfield(bofs(1),names{i});
fprintf(fid,'%s',names{i}(2:length(names{i})));
fprintf(fid,'\t');
	for j=1:length(v)
		fprintf(fid,'%d',v(j));
        if(j~=length(v))
		fprintf(fid,'%s',' ');
        end
	end
fprintf(fid,'\n');
end
fclose(fid);

%% ------------ASSIGNAR LA CLASSE A LA QUE PERTANY--------------------------
%Un cop carregat el fitxer d'entrenament, hem d'assignar la classe a la que
%pertany. Per a això, primer carreguem el fitxer de veritat terreny i
%després el fitxer que hem creat anteriorment (entrenar.txt)

display('Assignant classes al fitxer d"entrenament...');
%Càrrega del fitxer veritat_terreny
classifPath=uigetdir(pwd, 'Escull la carpeta "veritat_terreny"');
caracteristicas=dir(classifPath); 
pathT = strcat(classifPath,'\',caracteristicas(3).name);
    
formats ='%s%s';
headerLines=1;
delimiter='\t';
    
[matrix{1:2}] = textread(pathT, formats,'headerlines', headerLines, 'delimiter', delimiter);
    
id=matrix{1,1};
class=matrix{1,2};
    
map_class = containers.Map();

for i=1:length(matrix{1,1})
    map_class(id{i}) = class{i};
end
    
%Càrrega del fitxer entrenament.txt i assignem la classe
trainPath=uigetdir(pwd, 'Escull la carpeta "Imagenes_asignar_clase"');
directoryName=dir(trainPath); 
filePathTraining = strcat(trainPath,'\',directoryName(3).name);
    
formats ='%s%s';
headerLines=0;
delimiter='\t';
    
[train{1:2}] = textread(filePathTraining, formats,'headerlines', headerLines, 'delimiter', delimiter);
featuresVector = train{1,2};
nom2 = strcat('./Imagenes_entrenar', '/','Vector_amb_classe.txt');
fid2 = fopen(nom2,'wt');
   
for i=1:length(train{1,1}) %recorremos id de fotos
    idPhoto = train{1,1}{i};
    fprintf(fid2, '%s',idPhoto);
    fprintf(fid2,'\t');  
    
    s=featuresVector{i};
    sp=strsplit(s,' ');
            
    for z=1:length(sp)
        fprintf(fid2,'%s',sp{z});
            if(z~=length(sp))
                fprintf(fid2,'%s',',');
            end
            
            if(z==length(sp))
                fprintf(fid2,'\t');
            end
    end    
  
    eventType = values(map_class,{idPhoto}); %funcion q te da el valor de un map pasandole su key
        
    fprintf(fid2,'%s',eventType{1});
    fprintf(fid2,'\n');
end
 
 fclose(fid2);
 
 %% -----------CONSTRUCCIÓ DEL KD-TREE-------------------------------------
display('Construint el kd-tree...');
classifPath=uigetdir(pwd, 'Escull la carpeta "Imagenes_entrenar"');
caracteristicas=dir(classifPath); 
pathT = strcat(classifPath,'\',caracteristicas(3).name);
    
formats ='%s%s%s';
headerLines=0;
delimiter='\t';
[bbdd_train{1:3}] = textread(pathT, formats,'headerlines', headerLines, 'delimiter', delimiter);
    
nombres=bbdd_train{1,1};
vectores=bbdd_train{1,2};
clases=bbdd_train{1,3};
    
     
for i=1:length(vectores)
    row=strsplit(vectores{i},',');
        for j=1:length(row)
            element=str2num(row{j});
            m(i,j)=element;
        end    
end
 
tree_output = createns(m,'nsmethod','kdtree');

 display('Heu finalitzat amb èxit la construcció del kd-tree');
toc;
 

