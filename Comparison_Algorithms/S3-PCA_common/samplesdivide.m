function [DataTest, DataTrain, CTest, CTrain, test_index] = samplesdivide(hsi,gt,train,randpp)

[m, n, p] = size(hsi);
CTrain = [];CTest = [];
DataTest  = [];
DataTrain = [];
% map = uint8(zeros(m,n));
data_col = reshape(hsi,m*n,p);
test_index = [];

for i = 1:max(gt(:))
    class_num_i = length(find(gt==i));    
    [v]=find(gt==i);    
    datai = data_col(gt==i,:);
    if train>1
        cTrain = round(train);
    elseif train<1
        cTrain = round(class_num_i*train);
        cTrain(cTrain < 5) = 5;
    end
    if train>ceil(class_num_i/2)
        cTrain = ceil(class_num_i/2);
    end
    cTest  = class_num_i-cTrain;
    CTrain = [CTrain cTrain];
    CTest = [CTest cTest];
    index = randpp{i};
    DataTest = [DataTest; datai(index(1:cTest),:)];
    DataTrain = [DataTrain; datai(index(cTest+1:cTest+cTrain),:)];    
   
    test_index = [test_index; v(index(1:cTest))];
%     map(v(index(1:cTest))) = i;    
end

%%%%%%%% Normalize
DataTest = fea_norm(DataTest);
DataTrain = fea_norm(DataTrain);
