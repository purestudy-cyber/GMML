function [oa, aa, Ka, ca] = confusion(true_label,estim_label)
% This function compute the confusion matrix and extract the OA, AA
% and the Kappa coefficient.

l = length(true_label);
nb_c = max(true_label);

confu = zeros(nb_c, nb_c);

for i = 1:l
  confu(estim_label(i), true_label(i)) = confu(estim_label(i), true_label(i)) + 1;
end

oa = trace(confu)/sum(confu(:)); %overall accuracy
ca = diag(confu)./sum(confu,2);  %class accuracy
ca(isnan(ca)) = 0;
aa = mean(ca);

Po = oa;
Pe = (sum(confu)*sum(confu,2)) / (sum(confu(:))^2);
Ka = (Po-Pe)/(1-Pe); %kappa coefficient
