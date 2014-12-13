%SCRIPT CLASSIFICACIÓ

function classificador(tree_output,bbdd_train)

%% ----------CARREGUEM EL FITXER DE TEST .MAT------------------------------
tic;
display('Carregant fitxer de test...')
load('bofs_1000_test.mat');
names=fieldnames(bofs(1));

nom = strcat('./Imagenes_clasificar', '/','test.txt');
fid3=fopen(nom,'wt');

for i=1:length(names)
vt=getfield(bofs(1),names{i});
fprintf(fid3,'%s',names{i}(2:length(names{i})));
fprintf(fid3,'\t');
	for j=1:length(vt)
		fprintf(fid3,'%d',vt(j));
        if(j~=length(vt))
		fprintf(fid3,'%s',' ');
        end
	end
fprintf(fid3,'\n');
end
fclose(fid3);


%% -----------CLASSIFICAR DADES--------------------------------------------
display('Carregant dades per classificar...')
classifPath=uigetdir(pwd, 'Escull la carpeta "Imagenes_clasificar"');
    caracteristicasC=dir(classifPath); 
    pathT = strcat(classifPath,'\',caracteristicasC(3).name);
    
    formats ='%s%s';
    headerLines=0;
    delimiter='\t';
    [bbdd_test{1:2}] = textread(pathT, formats,'headerlines', headerLines, 'delimiter', delimiter);
    
    nombresC=bbdd_test{1,1};
    vectoresC=bbdd_test{1,2};
  
     
    for i=1:length(vectoresC)
   
        rowC=strsplit(vectoresC{i},' ');
        for j=1:length(rowC)
            elementC=str2num(rowC{j});
            c(i,j)=elementC;
        end    
    end
    
    [file,column]=size(c);
    
    fid4 = fopen('resultat.txt','wt');
    
    for z=1:file
        [index_vals,vector_vals,final_nodes] = kd_knn(tree_output,c(z,:),1,2);
        [className, filename, featureVector] = getElementsByFeatureVector(vector_vals, bbdd_train);
        
        fprintf(fid4, '%s',nombresC{z});
        fprintf(fid4,'%s',' ');
        fprintf(fid4,'%s',className{1});
        fprintf(fid4,'\n');
        
    end
    
    fclose(fid4);
    display('Classificacio finalitzada amb exit');
    toc;
end