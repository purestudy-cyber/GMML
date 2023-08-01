function [accuracy, aa, Ka, ca] = confusion_matrix(class, c)
%
% class is the result of test data after classification
%          (1 x n)
%
% c is the label for testing data
%          (1 x len_c)
%
%

class = class.';
c = c.';

n = length(class);
c_len = length(c);

if n ~= sum(c)
    disp('WRANING:  wrong inputting!');
    return;
end


% confusion matrix
confusion = zeros(c_len, c_len);
a = 0;
for i = 1: c_len
    for j = (a + 1): (a + c(i))
        confusion(i, class(j)) = confusion(i, class(j)) + 1;
    end
    a = a + c(i);
end


% True_positive_rate + False_positive_rate + accuracy
ca = zeros(1, c_len);
% FPR = zeros(1, c_len);
for i = 1: c_len
%   FPR(i) = confusion(i, i)/sum(confusion(:, i));
  ca(i) = confusion(i, i)/sum(confusion(i, :)); % 除以行和，应该就是CA
end
aa = mean(ca);
accuracy = sum(diag(confusion))/sum(c);

Po = accuracy;
Pe = (sum(confusion)*sum(confusion,2)) / (sum(confusion(:))^2);
Ka = (Po-Pe)/(1-Pe); %kappa coefficient
