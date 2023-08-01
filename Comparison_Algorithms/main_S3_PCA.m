% =========================================================================
% A simple demo for S^3-PCA based Unsupervised Feature Extraction of
% Hyperspectral Imagery
% If you  have any problem, do not hesitate to contact
% Zhang Xin (xinz2801@gmail.com)
% Version 1,2020-09-03

clc;clear;close all
addpath('../data');
addpath('S3-PCA_common');
addpath('Entropy Rate Superpixel Segmentation');

num_PC           =   30;  % THE OPTIMAL PCA DIMENSION.
iterNum          =   10;  % The Iteration Number

dataset_name         =   'botswana';

%% load the HSI dataset
if strcmp(dataset_name,'indianp')
    load IndianP;load Indian_pines_gt;load Indian_pines_randp 
    data3D = img;        gt = indian_pines_gt;
    trainpercentage  =   0.1;  % Training Number per Class
    num_Pixel        =   75;
    k                =   15;
elseif strcmp(dataset_name,'paviau')    
    load PaviaU;load PaviaU_gt;load PaviaU_randp; 
    data3D = paviaU;        gt = paviaU_gt;
    trainpercentage  =   0.1;  % Training Number per Class
    num_Pixel        =   30;
    k                =   13;
elseif strcmp(dataset_name,'salinas')
    load Salinas_corrected;load Salinas_gt;load Salinas_randp
    data3D = salinas_corrected;        gt = salinas_gt;
    trainpercentage  =   0.05;  % Training Number per Class
    num_Pixel        =   100;
    k                =   15;
elseif strcmp(dataset_name,'ksc')    
    load KSC_corrected;load KSC_gt;load ksc_randp; 
    data3D = KSC;        gt = KSC_gt;
    trainpercentage  =   0.05;  % Training Number per Class
    num_Pixel        =   75;
    k                =   15;
elseif strcmp(dataset_name,'botswana')    
    load Botswana;load Botswana_gt;load botswana_randp; 
    data3D = Botswana;        gt = Botswana_gt;
    trainpercentage  =   0.05;  % Training Number per Class
    num_Pixel        =   75;
    k                =   15;
elseif strcmp(dataset_name,'houston')    
    load Houston;load Houston_gt;load houston_randp; 
    data3D = double(Houston);        gt = Houston_gt;
    trainpercentage  =   0.05;  % Training Number per Class
    num_Pixel        =   60;
    k                =   20;
end

tic
data3D = data3D./max(data3D(:));
[rows, lines, bands] = size(data3D);

%% super-pixels segmentation
labels = cubseg(data3D,num_Pixel);

%% SupePCA based DR
[dataDR] = S3_PCA(data3D,num_PC,k,labels);
toc

classes = max(max(gt));
OA_all = zeros(iterNum, 1);
AA_all = zeros(iterNum, 1);
Kappa_all = zeros(iterNum, 1);
CA_all = zeros(iterNum, classes);

for iter = 1:iterNum

    tic
    randpp=randp{iter};     
    % randomly divide the dataset to training and test samples
    [DataTest, DataTrain, CTest, CTrain, test_index] = samplesdivide(dataDR,gt,trainpercentage,randpp);   

    % Get label from the class num
    trainlabel = getlabel(CTrain);
    testlabel  = getlabel(CTest);

    %% nearest neighbor
    dist = pdist2(DataTrain, DataTest, 'euclidean');
    test_sum = length(testlabel);
    predict_label = zeros(1, test_sum);
    [m1,n1] = min(dist);
    for i = 1 : test_sum
        predict_label(i) = trainlabel(n1(i));
    end

    [accuracy, aa, ka, ca] = confusion_matrix(predict_label', CTest);
    OA_all(iter) = accuracy;
    AA_all(iter) = aa;
    Kappa_all(iter) = ka;
    CA_all(iter, :) = ca;
    toc

    result = reshape(gt, rows * lines, 1);
    result(test_index) = predict_label;
    result = reshape(result, rows, lines);
    color_map = label2color(result, dataset_name);

    %figure;
    imshow(color_map);

    print_name = ['output\', dataset_name, '_map_S3-PCA','.eps'];
    print(print_name,'-depsc','-r600');
end
fprintf('\n=============================================================\n');
fprintf(['The average OA (10 iterations) of S3-PCA for ',dataset_name,' is %0.4f\n'],mean(OA_all));
fprintf('=============================================================\n');

OA_m = mean(OA_all);
OA_std = std(OA_all);
AA_m = mean(AA_all);
AA_std = std(AA_all);
Kappa_m = mean(Kappa_all);
Kappa_std = std(Kappa_all);
CA_m = mean(CA_all);
CA_std = std(CA_all);

if iterNum == 10
    save_name = ['output\', dataset_name, '_result_S3-PCA'];
    save(save_name, 'OA_m', 'OA_std', 'AA_m', 'AA_std', 'Kappa_m', 'Kappa_std', 'CA_m', 'CA_std')
end
