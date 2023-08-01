function [hsi, gt, para] = load_hsi(dataset_name)
switch lower(dataset_name)
    case 'indianp'
        data = load('data\IndianP.mat');
        hsi = data.img;
        data = load('data\Indian_pines_gt.mat');
        gt = data.indian_pines_gt;
        para.window = 9;
        para.neighborsize = 30;
        para.percent = 0.1;
    case 'paviau'
        data = load('data\PaviaU.mat');
        hsi = data.paviaU;
        data = load('data\PaviaU_gt.mat');
        gt = data.paviaU_gt;
        para.window = 9;
        para.neighborsize = 30;
        para.percent = 0.1;
    case 'salinas'
        data = load('data\Salinas_corrected.mat');
        hsi = data.salinas_corrected;
        data = load('data\Salinas_gt.mat');
        gt = data.salinas_gt;
        para.window = 7;
        para.neighborsize = 20;
        para.percent = 0.05;
    case 'ksc'
        data = load('data\KSC_corrected.mat');
        hsi = data.KSC;
        data = load('data\KSC_gt.mat');
        gt = data.KSC_gt;
        para.window = 9;
        para.neighborsize = 30;
        para.percent = 0.05;
    case 'botswana'
        data = load('data\Botswana.mat');
        hsi = data.Botswana;
        data = load('data\Botswana_gt.mat');
        gt = data.Botswana_gt;
        para.window = 11;
        para.neighborsize = 70;
        para.percent = 0.05;
    case 'houston'
        data = load('data\Houston.mat');
        hsi = data.Houston;
        data = load('data\Houston_gt.mat');
        gt = data.Houston_gt;
        para.window = 11;
        para.neighborsize = 40;
        para.percent = 0.05;
end