clear;
close all;
clc;

dataset_name = 'ksc';
[hsi, gt, para] = load_hsi(dataset_name);
% get hyperparameter
window = para.window;
neighborsize = para.neighborsize;
percent = para.percent;

d = 30; % Embedding dimension size
repeat_num = 1;

classes = max(max(gt));
Value = zeros(1, classes);
for n = 1:classes
    Value(n) = sum(sum(gt == n));
end
train_class_value = zeros(1, classes);

for n = 1:classes
    train_class_value(n) = max(5, round(Value(n) * percent));
end

[rows, lines, bands] = size(hsi);

data2D = reshape(hsi, [rows * lines, bands]);
data2D = normalize(data2D, 'range');

hsi = reshape(data2D, rows, lines, bands);

clear data2D

% Generate GroundT_index matrix
total_classes = sum(sum(gt ~= 0));
GroundT_index = zeros(2, total_classes);

from = 1;
for i = 1:classes
    temp = find(gt == i);
    num_temp = size(temp, 1);
    GroundT_index(1, from : from + num_temp - 1) = temp';
    GroundT_index(2, from : from + num_temp - 1) = repmat(i, 1, num_temp);
    from = from + num_temp;
end

OA_all = zeros(repeat_num, 1);
AA_all = zeros(repeat_num, 1);
Kappa_all = zeros(repeat_num, 1);
CA_all = zeros(repeat_num, classes);

% Recursively add Manopt directories to the Matlab path.
cd('manopt');
addpath(genpath(pwd()));
cd('..');

for repeat = 1:repeat_num
    fprintf('repeat_num = %d \n', repeat);
    tic
    % random selection
    indexes = train_test_random_select(GroundT_index(2,:), train_class_value);
    train_sum = sum(train_class_value);
    test_sum = sum(Value - train_class_value);
    train_cell = cell(1, train_sum);
    

    train_PL = GroundT_index(:, indexes);
    test_PL = GroundT_index;
    test_PL(:,indexes) = [];
    

    train_labels = train_PL(2,:);
    test_labels = test_PL(2,:);

    disp('compute cell')


    for i = 1:train_sum
        [row_range, col_range] = get_neighbor(train_PL(1,i), rows, lines, window);
        t_train2D = reshape(hsi(row_range, col_range, :), [window * window, bands]);
        train_cell{i} = gaussian_model_embed_log(t_train2D);
    end


    disp('compute train_k');

    gaussian_k = zeros(train_sum, train_sum);
    for i = 1:train_sum
        for j = 1:i
            gaussian_k(i, j) = spd_kernel(train_cell{i}, train_cell{j});
            gaussian_k(j, i) = gaussian_k(i, j);
        end
    end


    disp('Optimization');
    proj = Opti(gaussian_k, train_labels, neighborsize, d);

    toc

    disp('Dimensionality reduction');
    tic
    Reduced_train_k = proj' * gaussian_k;


    test_cell = cell(1, test_sum);
    for i = 1:test_sum
        [row_range, col_range] = get_neighbor(test_PL(1,i), rows, lines, window);
        t_test2D = reshape(hsi(row_range,col_range,:), [window * window, bands]);
        test_cell{i} = gaussian_model_embed_log(t_test2D);
    end

    Reduced_test_k = zeros(d, test_sum); % reduce memory usage
    gaussian_k_train_with_test = zeros(train_sum, 1);
    for i = 1 : test_sum
        for j = 1 : train_sum
            gaussian_k_train_with_test(j) = spd_kernel(train_cell{j}, test_cell{i});
        end
        Reduced_test_k(:, i) = proj' * gaussian_k_train_with_test;
    end

    %% Classification
    disp('Classification')
    %tic
    dist = pdist2(Reduced_train_k', Reduced_test_k', 'euclidean');

    xx = zeros(classes, test_sum);

    step = 0;
    for i = 1:classes
        xx(i,:) = min(dist(step + 1 : step + train_class_value(i), :));

        step = step + train_class_value(i);
    end
    ttest_labels = zeros(1, test_sum);

    for i = 1:test_sum
        ttest_labels(i) = find(xx(:,i) == min(xx(:,i)));
    end



    [OA, AA, Kappa, CA] = confusion(test_labels, ttest_labels);

    OA_all(repeat) = OA;
    AA_all(repeat) = AA;
    Kappa_all(repeat) = Kappa;
    CA_all(repeat, :) = CA;


    result = reshape(gt, rows * lines, 1);
    result(test_PL(1,:)) = ttest_labels;
    result = reshape(result, rows, lines);
    map = label2color(result, dataset_name);

    image_show_and_print(dataset_name, map);
    toc
end

OA_m = mean(OA_all);
OA_std = std(OA_all);
AA_m = mean(AA_all);
AA_std = std(AA_all);
Kappa_m = mean(Kappa_all);
Kappa_std = std(Kappa_all);
CA_m = mean(CA_all);
CA_std = std(CA_all);

if repeat_num == 10
    save_name = ['output\', dataset_name, '_result'];
    save(save_name, 'OA_m', 'OA_std', 'AA_m', 'AA_std', 'Kappa_m', 'Kappa_std', 'CA_m', 'CA_std')
end
