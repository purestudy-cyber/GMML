function proj = Opti(kernel, train_labels, k, d)
%     tic
    [weights, neighbor_index] = weight_opti(kernel, k);
%     toc
    disp('Get W.');

%     tic
    n = size(weights,1);
    num_w = 0;
    num_b = 0;

    G_w = zeros(n); % Within Graph
    G_b = zeros(n); % Between Graph

    class_num = max(train_labels);
    index_within = cell(1, class_num);
    index_between = cell(1, class_num);
    for i = 1 : class_num
        index_within{i} = find(train_labels == i);
        index_between{i} = find(train_labels ~= i);
    end

    for i = 1 : n
        neighbor_i = neighbor_index(:,i);

        inclass = index_within{train_labels(i)};
        inclass_sign = ismember(neighbor_i, inclass);
        inclass_neighbor = neighbor_index(inclass_sign, i);
        G_w(i,inclass_neighbor) = weights(i, inclass_neighbor);

        betweenclass = index_between{train_labels(i)};
        betweenclass_sign = ismember(neighbor_i, betweenclass);
        betweenclass_neighbor = neighbor_index(betweenclass_sign, i);
        G_b(i,betweenclass_neighbor) = weights(i, betweenclass_neighbor);

        num_w = num_w + sum(inclass_sign);
        num_b = num_b + sum(betweenclass_sign);
    end

    G = sparse(G_w/num_w - G_b/num_b);

%     toc
    disp('Get G.');

%     tic
    S = zeros(n);
    for i = 1 : n
        G_diag = diag(G(i,:));
        inter_kernel = repmat(kernel(:,i), 1, n) - kernel;
        S = S + sparse(inter_kernel * G_diag) * inter_kernel';
        % compute line by line (G) inter_kernel * inter_kernel' -> 
        % (k.1 - k.2)(k.1 - k.2)', (k.1 - k.3)(k.1 - k.3)',..., (k.1 - k.n)(k.1 - k.n)' when i = 1
    end
%     toc
    disp('Get S.');
    
%     tic
    [V, D] = eig(S);
    [~, index] = sort(diag(D));
    V_sort = V(:,index);
    proj = V_sort(:, 1:d);
%     toc
    disp('Get proj.');
end