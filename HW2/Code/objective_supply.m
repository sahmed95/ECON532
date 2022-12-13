function gmm = objective_supply(ns, n_markets,n_products, sigma, P_opt, nu, shares, Z, Z_inst,w,X,type)
    
    % Demand side 

    delta = meanutility(ns, n_markets, n_products, sigma, P_opt, nu, shares);
    theta = parameters(delta, X, P_opt, Z_inst);
    X_all = [X, reshape(P_opt, [],1)]; 
    X_theta = X_all*theta; 
    xi_hat = reshape(delta, [],1)-X_theta;

    % Supply side 
    derivative = calculate_derivative(theta,ns, n_markets, n_products, P_opt, nu, sigma, delta);
    shares_sim = marketshare(ns, n_markets, n_products, sigma, P_opt, delta, nu);
    w_hat = [ones(n_products*n_markets,1), w, Z];
     
    if type == "olig"
        markup = calculate_markup_olig(n_products,n_markets, derivative, shares_sim);
    elseif type == "col"
        markup = calculate_markup_col(n_products, n_markets, derivative, shares_sim); 
    else 
        markup = zeros(n_products, n_markets); 
    end
    omega = calculate_omega(P_opt, markup, w_hat, Z_inst);

    % Residuals 
    residuals = [xi_hat;omega]; 

    W = inv(Z_inst'*Z_inst); 

    % Doubling the instruments
    Z_2 = blkdiag(Z_inst, Z_inst); 
    W_2 = blkdiag(W, W);

    % Objective 
    gmm = residuals'*Z_2*W_2*Z_2'*residuals; 
end 

  
      