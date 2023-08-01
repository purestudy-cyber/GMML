clc
clear
close all

addpath(genpath(cd));

dataset_name = 'houston';

data = load('Houston.mat');
hsi = data.Houston;
data = load('Houston_gt.mat');
gt = data.Houston_gt;

IterNum = 10;
randp = randpGen(gt, IterNum);
save([dataset_name '_randp.mat'], "randp");
