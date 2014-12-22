%Funció que et retorna el % d'imatges que entrenarem i classificarem

function [resultTrain,resultTest] = get_kcrossval(total,ids,vectores, porcentTrain, porcentTest)

num=randi([1,total]);
totalTrain=(porcentTrain/100)*total;
totalTest=(porcentTest/100)*total;
resultTrain={};

%Recorrer las train
count = 0;
index = num;
i=1;
while count <= totalTrain
    if index > totalTrain
        index = 1;
    end
    resultTrain{1,1}(i) = ids(index);
    resultTrain{1,2}(i,:) = vectores(index,:);
    index = index + 1;
    count = count + 1;
    i=i+1;
end

%Recorrer las test
count = 0;
resultTest = [];
index = num-1;
i=1;
while count <= totalTest
    if index <= 0
        index = total;
    end
    resultTest{1,1}(i) = ids(index);
    resultTest{1,2}(i,:) = vectores(index,:);
    index = index -1;
    i = i+1;
    count = count +1;
end



