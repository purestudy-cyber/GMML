function [weights, neighbor_index] = weight_opti(kernel, k)
    n = size(kernel, 1);
    temp_d = diag(kernel);
    kdist = repmat(temp_d',n,1) + repmat(temp_d,1,n) - 2 * kernel;

    [~,index] = sort(kdist);
    neighbor_index = index(2:(1+k),:);

    weights = zeros(n);

    for i = 1:n
        qi = neighbor_index(:,i);
        Hi = repmat(kernel(i,i),k,k) + kernel(qi,qi) - repmat(kernel(i,qi),k,1) - repmat(kernel(qi,i),1,k);
        weight_i = multinomial_opti(Hi); % multinomial manifold optimization
        weights(i, qi) = weight_i;
    end

    weights = (weights + weights') / 2;

    function w = multinomial_opti(H)
        manifold = multinomialfactory(k, 1);
        problem.M = manifold;
        problem.cost  = @(x) x'*H*x;
        problem.egrad = @(x) 2*H*x;

        %checkgradient(problem);

        options.verbosity = 0;
        [w, ~, ~, ~] = conjugategradient(problem, [], options);
    end
end