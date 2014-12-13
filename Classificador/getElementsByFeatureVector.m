function [className, filename, featureVector] = getElementsByFeatureVector(vector, bbdd)
      for i=1:length(bbdd)
        filename = bbdd{1,1}(i);
        vectorC = bbdd{1,2}{i};
        className = bbdd{1,3}(i);

        
        vectorS=strsplit(vectorC,',');
        for j=1:length(vectorS)
            element=str2num(vectorS{j});
            featureVector(j)=element;
        end    
    
        if isequal(vector, featureVector)
           return;
        end
    end
end