function examengdsa2(miMap)

tic;
%EXTRAER ID DE LAS FOTOS Y GUARDAR EN UN TXT
display('Extrayendo id de las fotos y guardando en un .txt');

%PONER DIRECTORIO DE LA CARPETA DONDE ESTÁN LAS FOTOS A CLASIFICAR
%------------------------------------------------------------------------------
a=dir(fullfile('C:\UPC\4t\GDSA\Proyecto\Proyecto_Git\Classificador\cristina'));
%-------------------------------------------------------------------------------
fi=fopen('id.txt','wt');
for i=3:length(a)
    a(i).name=a(i).name(1:end-4);
    fprintf(fi,'%s\n',a(i).name);
end 
fclose(fi);

%Leer el txt con las id's. El fichero txt será el que nos de el Giro en el
%examen una vez extraidas las id's de las fotos
filePathTraining=('C:\UPC\4t\GDSA\Proyecto\Proyecto_Git\Classificador\id.txt'); 
formats='%s';
headerLines=0;
delimiter='\n';
ids{1:1}=textread(filePathTraining, formats,'headerlines',headerLines,'delimiter', delimiter);

display('Asociando id con vector');
%Ponemos una "i" delante a cada id
cont=1;
for i=1:length(ids{1})
foto(i)=strcat('i',ids{1}(i));
v(i) = values(miMap,{foto{i}});
    if cont==1
        S=struct(foto{i},v(i));
        cont=cont+1;
    else
        S=setfield(S,foto{i},v{i});
    end
end

save 'bofs_examen.mat' S;
toc;
