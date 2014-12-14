%obrim el fitxer de dades del veritat terreny i el fitxer de dades del
%classificador
veritat_terreny= uigetfile('*.csv','Selecciona fitxer amb les dades de veritat terreny');
FID=fopen(veritat_terreny);
VT = textscan(FID, '%s%s');%llegeix dades d'un arxiu de text obert identificat per la FID
fclose(FID);
% -%S string
clasificador= uigetfile('*.txt','Selecciona fitxer amb les dades del clasificador');
FID1=fopen(clasificador);
C = textscan(FID1, '%s%s'); %llegeix dades d'un arxiu de text obert identificat per la FID 
fclose(FID1); 
 
%dades del fitxer veritat terreny i del fitxer generat del classificador
id=VT{:,1}; % A la primera columna hi han les ids de les imatges
event=VT{:,2};% A la segona columna hi ha l'event al que pertany cada id
event=event';
LVeritat=length(event); %Obtenim la llargada del vector que conté la veritat terreny. 
 
idC=C{:,1}; % A la primera columna hi han les ids de les imatges
eventC=C{:,2}; % A la segona columna hi ha l'event al que pertany cada id
eventC=eventC';
LClas=length(eventC); %Obtenim la llargada del vector que conté les imatges classificades.
 

 
%pasem el vector de veritat terrent de id i event a un map
map_veritat = containers.Map();
for i=1:LVeritat
    map_veritat(id{i}) = event{i};
end
 
 
for i=1:LClas
    idm = idC{i};
    if(isKey(map_veritat,idm) == 1) %Si l'id existeix a la veritat terreny l'agafem, sinó no fem res
        id{i} = idm;
        event{i} = map_veritat(idm);
    end    
end

 
%per utilitzar la funcio "getcm" que genera parametres d'avaluacio, els vectors de clases de les imatges i la
%veritat terreny han d'estar classificades en enters
%strcmp compara si la posició del vector es la mateixa que fashion, non-event....
%generem el vector d'enters del Veritat terreny
v = zeros(1,LVeritat); %l'emplenem de 0 perque els dos vectors v i c d'enters siguin de la mateixa llargaria.
for i=1:LVeritat
    if strcmp(event(i),'fashion')
        v(i)=1;
        elseif strcmp(event(i),'concert')
        v(i)=2;
        elseif strcmp(event(i),'non_event')
        v(i)=3;
        elseif strcmp(event(i),'exhibition')
        v(i)=4;
        elseif strcmp(event(i),'sports')
        v(i)=5;
        elseif strcmp(event(i),'protest')
        v(i)=6;
        elseif strcmp(event(i),'theater_dance')
        v(i)=7;
        elseif strcmp(event(i),'conference')
        v(i)=8;
        elseif strcmp(event(i),'other')
        v(i)=9;   
    end;
    
end;
 
%generem el vector d'enters del Classificador
 
c = zeros(1,LVeritat);%l'emplenem de 0 perque els dos vectors v i c d'enters siguin de la mateixa llargaria.
for i=1:LClas
    if strcmp(eventC(i),'fashion')
        c(i)=1;
        elseif strcmp(eventC(i),'concert')
        c(i)=2;
        elseif strcmp(eventC(i),'non_event')
        c(i)=3;
        elseif strcmp(eventC(i),'exhibition')
        c(i)=4;
        elseif strcmp(eventC(i),'sports')
        c(i)=5;
        elseif strcmp(eventC(i),'protest')
        c(i)=6;
        elseif strcmp(eventC(i),'theater_dance')
        c(i)=7;
        elseif strcmp(eventC(i),'conference')
        c(i)=8;
        elseif strcmp(eventC(i),'other')
        c(i)=9; 
    end;
    
end;
%vector=1:9;
%cridem a la funcio que ens dona els resultats
[mconfusio,numcorrecte,precisio,recall,fscore] = getcm(v,c,(1:9))
%Contem quantes classes hi ha a la veritat terreny i al classificador
cont = 0;
for j=1:9
    for i=1:length(v)
        if v(i)==j
            cont = cont + 1;
            break; %si troba la classe surt del for i va a la seguent classe del classificador per mirar si està també en el vector veritat terreny
        end
    end
end
 
%calculs de les mitjanes 
Precisio = sum(precisio)/cont;
Recall = sum(recall)/cont;
Fscore = sum(fscore)/cont;
Exactitud=(numcorrecte/LClas)*100;

 
 
%creació del fitxer de resultats
fid=fopen('resultats.txt','w');
 
fprintf(fid,'Precisió=');
fprintf(fid,'%f \n',Precisio);
fprintf(fid,'\n');
 
fprintf(fid,'Recall=');
fprintf(fid,'%f \n',Recall);
fprintf(fid,'\n');
 
fprintf(fid,'Fscore=');
fprintf(fid,'%f \n',Fscore);
fprintf(fid,'\n');
 
fprintf(fid,'Exactitud=');
fprintf(fid,'%f \n',Exactitud);
fprintf(fid,'\n');

fprintf(fid,'Matriu de confusió=');
fprintf(fid,'%f \n');
fprintf(fid,'\n');

for i=1:9
 
    for j=1:9
        fprintf(fid,'%f\t',mconfusio(i,j));
    end;
    
    fprintf(fid,'\n');
 
end;
 
fclose(fid);
