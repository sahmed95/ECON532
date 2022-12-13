function elasticity = calculate_elasticity(theta, ns, n_markets, n_products, P_opt, nu,sigma, delta)
    % Function to calculate the cross price and own price elasticities 

    % Calculationg the derivative of shares with respect to price s
    derivative =calculate_derivative(theta, ns, n_markets, n_products, P_opt, nu, sigma, delta);
    
    % Computing elasticity by multiplying by price/share
    
    deriv_prod = derivative.*(reshape(P_opt, [],1));
    sim_shares = marketshare(ns, n_markets, n_products, sigma, P_opt, delta, nu);
    Shares = repelem(sim_shares', n_products, 1);
    elasticity = deriv_prod./Shares;
end 