%SCRIPT CLASSIFICACIÓ

function classificador(tree_output,bbdd_train,m)

%% ----------CARREGA DEL FITXER DE TEST .MAT-------------------------------
tic;
display('Carregant fitxer de test...')
load('bofs_examen.mat'); %Es pot canviar
names=fieldnames(S(1));

nom = strcat('./Imagenes_clasificar', '/','test.txt');
fid3=fopen(nom,'wt');

for i=1:length(names)
vt=getfield(S(1),names{i});
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
%Un cop hem carregat el fitxer .mat per classificar, el llegim i cridem a
%la funció kd_knn per tal de veure els k-veins més propers i seguidament a
%la funció getElementsByFeatureVector, que ens retornarà la classe dels
%k-veins més propers. 

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
    
[row,column]=size(c);
    
fid4 = fopen('resultat_classificacio.txt','wt');
    
for z=1:row
    [idx, dist] = knnsearch(tree_output,c(z,:),'k',1);
    %Treiem la classe
    [className, filename, featureVector] = getElementsByFeatureVector(m(idx,:), bbdd_train);
 
        
    fprintf(fid4, '%s',nombresC{z});
    fprintf(fid4,'%s',' ');
    fprintf(fid4,'%s',className{1});
    fprintf(fid4,'\n');
end
    
fclose(fid4);
display('Classificacio finalitzada amb exit');
toc;
end