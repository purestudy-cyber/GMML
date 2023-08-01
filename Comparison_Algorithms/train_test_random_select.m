function [indexes] = train_test_random_select(y, Value)
% function to ramdonly select training samples and testing samples from the
% whole set of ground truth.
% all train is the ground truth

K = max(y);

% generate the training set

train_sum = sum(Value);
indexes_c = zeros(train_sum,1);
step = 1;

for i=1:K
    index1 = find(y == i);
    per_index1 = randperm(length(index1));
    Number = per_index1(1:Value(i));
    indexes_c(step : step+length(Number)-1) = index1(Number);
    step = step + length(Number);
end

indexes = indexes_c(:);