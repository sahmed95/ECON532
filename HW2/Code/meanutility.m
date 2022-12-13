function delta = meanutility(ns, n_markets, n_products, sigma, P_opt, nu,shares)
    % This function finds the fixed point using the contraction map 
    
    % tolerance level 
    tol = 1e-5;
    % initial guess for delta 
    delta = ones(n_products, n_markets);
    error = 1; 
    while error > tol
        share_new = marketshare(ns, n_markets, n_products, sigma, P_opt, delta, nu);
        val = log(shares)-log(share_new);
        delta_new = delta + val;
        error = norm(val); 
        delta = delta_new; 
    end 
end