%% Obtenció Contenidor Veritat Terreny per assignar posteriorment les classes al train

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

%% Obtenció del fitxer a realitzar la validació creuada

display('Carregant fitxer de train .mat ...');
load('bofs_train_256_100_2.mat');  %es pot canviar
names=fieldnames(bofs(1));
nom = strcat('./Validacio_creuada', '/','creuada.txt');
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


classifPath=uigetdir(pwd, 'Escull la carpeta "Validacio_creuada"');
caracteristicas=dir(classifPath); 
pathT = strcat(classifPath,'\',caracteristicas(3).name);
    
formats ='%s%s';
headerLines=1;
delimiter='\t';
    
[matrix{1:2}] = textread(pathT, formats,'headerlines', headerLines, 'delimiter', delimiter);
    
ids=matrix{1,1};
vectores=matrix{1,2};

%% Obtenció de les parts a entrenar i validar per fer el kcros validation
porcentTrain = 70;
porcentTest = 30;
train = {};
test = {};
l=length(ids);
k=5;
for i=1:length(vectores)
    row=strsplit(vectores{i},' ');
        for j=1:length(row)
            element=str2num(row{j});
            vNums(i,j)=element;
        end    
end
for i=1:k
    [train{1,i}, test{1,i}] = get_kcrossval(l,ids,vNums, porcentTrain, porcentTest);    
    currentTrain = train{1,i};
    currentIds = currentTrain{1,1};
    currentVectors = currentTrain{1,2};
    for j=1:length(currentIds)   
        id = currentTrain{1,1}(j);
        eventType = values(map_class,id); %funcion q te da el valor de un map pasandole su key
        train{1,i}{1,3}(j) = eventType;
    end
%     m = [];
%     for z=1:length(currentVectors)
%         for t=1:length(currentVectors(z))
%             m(z,t)=currentVectors(z,:);
%         end      
%         
%     end
    
    %Kdtree para cada k
    tree_output = kd_buildtree(currentVectors,2); %Construcció del kd-tree    
    train{1,i}{1,4} = tree_output;      
end



%% Clasificació

 
  
fid2 = fopen('resultat_kfold_1.txt','wt');

for z=1:length(test{1,1}{1,1})
    %Vector_vals retorna el vector al que més s'assembla. El 3r paràmetre és la K
    [index_vals,vector_vals,final_nodes] = kd_knn(train{1,1}{1,4},test{1,1}{1,2}(z,:),1,2); 

     %Treiem la classe a la que pertany vector_vals.
    [className, filename, featureVector] = getElementsByFeatureVector_kcross(vector_vals, train{1,1});            

    fprintf(fid2,'%s',test{1,1}{1,1}{z});
    fprintf(fid2,'%s',' ');
    fprintf(fid2,'%s',className{1});
    fprintf(fid2,'\n');
end    
fclose(fid2);


fid3 = fopen('resultat_kfold_2.txt','wt');
    
    for z=1:length(test{1,2}{1,1})
        %Vector_vals retorna el vector al que més s'assembla. El 3r paràmetre és la K
        [index_vals,vector_vals,final_nodes] = kd_knn(train{1,2}{1,4},test{1,2}{1,2}(z,:),1,2); 

         %Treiem la classe a la que pertany vector_vals.
        [className, filename, featureVector] = getElementsByFeatureVector_kcross(vector_vals, train{1,2});            

        fprintf(fid3,'%s',test{1,2}{1,1}{z});
        fprintf(fid3,'%s',' ');
        fprintf(fid3,'%s',className{1});
        fprintf(fid3,'\n');
    end    
    fclose(fid3);
    
fid4 = fopen('resultat_kfold_3.txt','wt');

for z=1:length(test{1,3}{1,1})
    %Vector_vals retorna el vector al que més s'assembla. El 3r paràmetre és la K
    [index_vals,vector_vals,final_nodes] = kd_knn(train{1,3}{1,4},test{1,3}{1,2}(z,:),1,2); 

     %Treiem la classe a la que pertany vector_vals.
    [className, filename, featureVector] = getElementsByFeatureVector_kcross(vector_vals, train{1,3});            

    fprintf(fid4,'%s',test{1,3}{1,1}{z});
    fprintf(fid4,'%s',' ');
    fprintf(fid4,'%s',className{1});
    fprintf(fid4,'\n');
end    
fclose(fid4);
    
fid5 = fopen('resultat_kfold_4.txt','wt');

for z=1:length(test{1,4}{1,1})
    %Vector_vals retorna el vector al que més s'assembla. El 3r paràmetre és la K
    [index_vals,vector_vals,final_nodes] = kd_knn(train{1,4}{1,4},test{1,4}{1,2}(z,:),1,2); 

     %Treiem la classe a la que pertany vector_vals.
    [className, filename, featureVector] = getElementsByFeatureVector_kcross(vector_vals, train{1,4});            

    fprintf(fid5,'%s',test{1,4}{1,1}{z});
    fprintf(fid5,'%s',' ');
    fprintf(fid5,'%s',className{1});
    fprintf(fid5,'\n');
end    
fclose(fid5);

fid6 = fopen('resultat_kfold_5.txt','wt');

for z=1:length(test{1,5}{1,1})
    %Vector_vals retorna el vector al que més s'assembla. El 3r paràmetre és la K
    [index_vals,vector_vals,final_nodes] = kd_knn(train{1,5}{1,4},test{1,5}{1,2}(z,:),1,2); 

     %Treiem la classe a la que pertany vector_vals.
    [className, filename, featureVector] = getElementsByFeatureVector_kcross(vector_vals, train{1,5});            

    fprintf(fid6,'%s',test{1,5}{1,1}{z});
    fprintf(fid6,'%s',' ');
    fprintf(fid6,'%s',className{1});
    fprintf(fid6,'\n');
end    
fclose(fid6);
    


    
    