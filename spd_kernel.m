function result = spd_kernel(m1, m2)
temp1 = m1(:);
temp2 = m2(:);
result = temp1' * temp2; % Tr(AB)
% faster than sum(sum(m1 .* m2))
end