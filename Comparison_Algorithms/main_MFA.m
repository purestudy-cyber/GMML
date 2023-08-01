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
    k = 4; 
    k1 = k;
    beta = 20;
    k2 = beta*k;
elseif strcmp(dataset_name,'paviau')
    k = 9;
    k1 = k;
    beta = 20;
    k2 = beta*k;
elseif strcmp(dataset_name,'salinas')    
    k = 9; 
    k1 = k;
    beta = 20;
    k2 = beta*k;
elseif strcmp(dataset_name,'ksc')    
    k = 7;
    k1 = k;
    beta = 20;
    k2 = beta*k;
elseif strcmp(dataset_name,'botswana')    
    k = 8;
    k1 = k;
    beta = 20;
    k2 = beta*k;
elseif strcmp(dataset_name,'houston')    
    k = 1;
    k1 = k;
    beta = 20;
    k2 = beta*k;
end

[rows, lines, bands] = size(hsi);

data2D = reshape(hsi, [rows * lines, bands]);
data2D = normalize(data2D, 'range'); % min-max归一化


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
    

    train_SL = GroundT2(:, indexes);
    test_SL = GroundT2;
    test_SL(:,indexes) = [];
    

    train_samples = data2D(train_SL(1,:),:)';
    train_labels = train_SL(2,:);
    test_samples = data2D(test_SL(1,:),:)';
    test_labels = test_SL(2,:);

    neighbor_index = zeros(k1, train_sum);
    sdist = pdist2(train_samples', train_samples', 'euclidean');

    t1 = 1;
    for i = 1 : classes
        t2 = t1 + Value_train(i) - 1;

        tsdist = zeros(train_sum, train_sum);
        tsdist = tsdist + Inf;
        tsdist(t1:t2,t1:t2) = sdist(t1:t2,t1:t2);
        [~, index] = sort(tsdist);
        neighbor_index(:, t1:t2) = index(2:(1+k1), t1:t2);

        t1 = t2 + 1;
    end

    b_neighbor_index = zeros(k2, train_sum);
    t1 = 1;
    for i = 1 : classes
        t2 = t1 + Value_train(i) - 1;

        btsdist = sdist;
        btsdist(t1:t2,t1:t2) = Inf;
        [~, bindex] = sort(btsdist);
        b_neighbor_index(:, t1:t2) = bindex(1:k2, t1:t2);

        t1 = t2 + 1;
    end

    Ww = zeros(train_sum, train_sum);
    Wb = zeros(train_sum, train_sum);

    for i = 1 : train_sum
        Ww(i, neighbor_index(:,i)) = 1;
        Ww(neighbor_index(:,i),i) = 1;
    end

    for i = 1 : train_sum
        Wb(i, b_neighbor_index(:,i)) = 1;
        Wb(b_neighbor_index(:,i),i) = 1;
    end

    Dw = diag(sum(Ww, 2));
    Db = diag(sum(Wb, 2));

    Mw = Dw - Ww;
    Mb = Db - Wb;

    templeft = train_samples * Mb * train_samples';
    tempright = train_samples * Mw * train_samples';
    templeft = (templeft + templeft')/2; 
    tempright = (tempright + tempright')/2;

    [V1,D1] = eig(templeft, tempright);
    V = real(V1); 
    D = real(D1);
    [~, eindex] = sort(diag(D), 'descend');
    V_sort = V(:, eindex);
    proj = V_sort(:, 1:d);
    toc

    tic
    reduced_data = proj' * train_samples;
    reduced_testdata = proj' * test_samples;

    %% Classification
    disp('Classification')
    dist = pdist2(reduced_data', reduced_testdata', 'euclidean');

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
print_name = ['output\', dataset_name, '_map_MFA','.eps'];
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
    save_name = ['output\', dataset_name, '_result_MFA'];
    save(save_name, 'OA_m', 'OA_std', 'AA_m', 'AA_std', 'Kappa_m', 'Kappa_std', 'CA_m', 'CA_std')
end
