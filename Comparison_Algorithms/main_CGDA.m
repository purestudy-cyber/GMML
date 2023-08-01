clear;
close all;
clc;

dataset_name = 'botswana';
[hsi, gt, para] = load_hsi(dataset_name);
% get hyperparameter
% window = para.window;
% neighborsize = para.neighborsize;
percent = para.percent;

d = 30; % Embedding dimension size
repeat_num = 1;

classes = max(max(gt)); 
Value = zeros(1, classes); 
for n = 1:classes
    Value(n) = sum(sum(gt == n));
end
Value_train = zeros(1, classes); 


for n = 1:classes
    Value_train(n) = max(5, round(Value(n) * percent));
end


if strcmp(dataset_name,'indianp')
    lambda = 1e-2;
elseif strcmp(dataset_name,'paviau')
    lambda = 1;
elseif strcmp(dataset_name,'salinas')    
    lambda = 1;
elseif strcmp(dataset_name,'ksc')    
    lambda = 0.01;
elseif strcmp(dataset_name,'botswana')    
    lambda = 1;
elseif strcmp(dataset_name,'houston')    
    lambda = 0.1;
    hsi = double(hsi);
end

[rows, lines, bands] = size(hsi);

data2D = reshape(hsi, [rows * lines, bands]);
data2D = normalize(data2D', 'norm')'; 


total_classes = sum(sum(gt ~= 0));
GroundT2 = zeros(2, total_classes);

from = 1;
for i = 1:classes
    temp = find(gt == i);
    num_temp = size(temp, 1);
    GroundT2(1, from : from + num_temp - 1) = temp';
    GroundT2(2, from : from + num_temp - 1) = repmat(i, 1, num_temp);
    from = from + num_temp;
end

OA_all = zeros(repeat_num, 1);
AA_all = zeros(repeat_num, 1);
Kappa_all = zeros(repeat_num, 1);
CA_all = zeros(repeat_num, classes);

for repeat = 1:repeat_num
    fprintf('repeat_num = %d \n', repeat);
    tic
    % random selection
    indexes = train_test_random_select(GroundT2(2,:), Value_train);
    train_sum = sum(Value_train);
    test_sum = sum(Value - Value_train);
%   train_cell = cell(1, train_sum);
    

    train_SL = GroundT2(:, indexes);
    test_SL = GroundT2;
    test_SL(:,indexes) = [];
    

    train_samples = data2D(train_SL(1,:),:)';
    train_labels = train_SL(2,:);
    test_samples = data2D(test_SL(1,:),:)';
    test_labels = test_SL(2,:);

    Wclass = cell(classes, 1);
    for i = 1 : classes
        num = Value_train(i);
        Wclass{i} = zeros(num, num);
        cindex = zeros(num, num-1);
        for j = 1:num
            t = 1:num;
            t(j) = [];
            cindex(j, :) = t;
        end
        ctrain_samples = train_samples(:, train_labels==i);
        for j = 1:num
            x = ctrain_samples(:,j);
            jctrain = ctrain_samples;
            jctrain(:,j) = [];
            w = (jctrain'*jctrain + lambda*eye(num-1)) \ jctrain' * x;
            Wclass{i}(j, cindex(j, :)) = w;
        end
    end
    W = blkdiag(Wclass{:});

    Ls = (eye(train_sum)-W)'*(eye(train_sum)-W);
    templeft = train_samples * Ls * train_samples';
    tempright = train_samples * train_samples';

    [V,D] = eig(templeft, tempright);
    [~, eindex] = sort(diag(D));
    V_sort = V(:, eindex);
    proj = V_sort(:, 1:d);
    toc

    tic
    reduced_data = train_samples' * proj;
    reduced_testdata = test_samples' * proj;

    %% Classification
    disp('Classification')
    dist = pdist2(reduced_data, reduced_testdata, 'euclidean');

    xx = zeros(classes, test_sum);

    step = 0;
    for i = 1:classes
        xx(i,:) = min(dist(step + 1 : step + Value_train(i), :));
       
        step = step + Value_train(i);
    end
    ttest_labels = zeros(1, test_sum);
    
    for i = 1:test_sum
        ttest_labels(i) = find(xx(:,i) == min(xx(:,i)));
    end
    

    [OA, AA, Kappa, CA] = confusion(test_labels,ttest_labels);
    
    OA_all(repeat) = OA;
    AA_all(repeat) = AA;
    Kappa_all(repeat) = Kappa;
    CA_all(repeat, :) = CA;

    
    result = reshape(gt, rows * lines, 1);
    result(test_SL(1,:)) = ttest_labels;
    result = reshape(result, rows, lines);
    map = label2color(result, dataset_name);
    %figure;
    imshow(map);

    toc
end
print_name = ['output\', dataset_name, '_map_CGDA','.eps'];
print(print_name,'-depsc','-r600');

OA_m = mean(OA_all);
OA_std = std(OA_all);
AA_m = mean(AA_all);
AA_std = std(AA_all);
Kappa_m = mean(Kappa_all);
Kappa_std = std(Kappa_all);
CA_m = mean(CA_all);
CA_std = std(CA_all);

if repeat_num == 10
    save_name = ['output\', dataset_name, '_result_CGDA'];
    save(save_name, 'OA_m', 'OA_std', 'AA_m', 'AA_std', 'Kappa_m', 'Kappa_std', 'CA_m', 'CA_std')
end
