clear;
close all;
clc;

dataset_name = 'houston';
[hsi, gt, para] = load_hsi(dataset_name);
% get hyperparameter
percent = para.percent;

repeat_num = 10;

classes = max(max(gt));
Value = zeros(1, classes);
for n = 1:classes
    Value(n) = sum(sum(gt == n));
end
Value_train = zeros(1, classes);

for n = 1:classes
    Value_train(n) = max(5, round(Value(n) * percent));
end

[rows, lines, bands] = size(hsi);

data2D = reshape(hsi, [rows * lines, bands]);
data2D = normalize(data2D, 'range');

data3D = reshape(data2D, rows, lines, bands);

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
    train_cell = cell(1, train_sum);
    
    train_SL = GroundT2(:, indexes);
    test_SL = GroundT2;
    test_SL(:,indexes) = [];
    
    train_samples = data2D(train_SL(1,:),:)';
    train_labels = train_SL(2,:);
    test_samples = data2D(test_SL(1,:),:)';
    test_labels = test_SL(2,:);
  
    %% Classification
    disp('Classification')
    dist = pdist2(train_samples', test_samples', 'euclidean');

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
print_name = ['output\', dataset_name, '_map_RAW','.eps'];
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
    save_name = ['output\', dataset_name, '_result_RAW'];
    save(save_name, 'OA_m', 'OA_std', 'AA_m', 'AA_std', 'Kappa_m', 'Kappa_std', 'CA_m', 'CA_std')
end
