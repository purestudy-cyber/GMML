function result = gaussian_model_embed_log(data)
    m = mean(data)';
    c = cov(data) + eye(size(data, 2))*(1e-6); % add a prior for numerical stability
    
    % embedding of Gaussian component
    Ptemp = [c+m*m' m; m' 1];
    L = chol(c);
    Ldet = det(L')^(-2/size(Ptemp, 1));
    % if det(L')-->0, Ldet-->+inf, avoid this situation
    if Ldet == inf
        Ldet = 1;
    end
    P = Ldet * Ptemp;
    % Avoid repeated calculation, calculate the matrix log in advance
    result = logm(P);
end