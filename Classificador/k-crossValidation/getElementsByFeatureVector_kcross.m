%Funci� que, donat els k-veins m�s propers, ens retornar� la classe, la id
%i el vector. Compara que el vector que retorna el kd_knn sigui igual al
%vector de la base de dades d'entrenament per tal de retornar la classe a
%la que pertany.

function [className, filename, vectorC] = getElementsByFeatureVector_kcross(vector, bbdd)

      
    for i=1:length(bbdd)
        filename = bbdd{1,1}(i);
        vectorC = bbdd{1,2}(i,:);
        className = bbdd{1,3}(i);

        if isequal(vector, vectorC)
           return;
        end
    end
end