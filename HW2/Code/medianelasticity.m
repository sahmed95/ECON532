function med_elasticity = medianelasticity(theta, ns, n_markets, n_products, P_opt, nu, sigma, delta)
    elasticity = calculate_elasticity(theta, ns, n_markets, n_products, P_opt, nu, sigma, delta); 
    % Median elasticity 
    elasticity_re = [];
    for i=1:n_markets
        block = elasticity((i-1)*n_products+1:i*n_products,:);
        block = reshape(block, n_products*n_products, 1);
        elasticity_re = [elasticity_re, block]; 
    end
    
    median_elasticity_re =  median(elasticity_re, 2);
    med_elasticity = reshape(median_elasticity_re, n_products, n_products)';