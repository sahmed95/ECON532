function se = standarderror(theta_final,n_products, ns, n_markets, nu, shares, Z_inst, delta, X, P_opt)
    % Calculating the covariance matrix 
    h = 0.1; 
    sigma = theta_final(5);
    theta = theta_final(1:4);
    n = n_products*n_markets;
    % Using the central difference formula for the derivative of delta
    delta_minus= meanutility(ns, n_markets,n_products, sigma-h, P_opt, nu, shares);
    delta_plus = meanutility(ns, n_markets, n_products,sigma+h, P_opt, nu, shares);
    grad_delta = (delta_plus-delta_minus)/(2*h); 
    grad = [reshape(grad_delta,[],1), -X,reshape(P_opt,[],1)]; 
    G = (1/n)*Z_inst'*grad; 
    X_all = [X, reshape(P_opt, [],1)]; 
    X_theta = X_all*theta; 
    xi_hat = reshape(delta, [],1)-X_theta;
    xi_hat_Z = xi_hat.*Z_inst; 
    Omega = (1/n)*(xi_hat_Z)'*xi_hat_Z; 
    GWG = G'*G;  % calculates G'WG
    GW = G';   % calculates G'W
    V = (1/n)*inv(GWG)*GW*Omega*G*inv(GWG);
    
    % Standard errors
    var =diag(V);
    se=sqrt((1/n)*var);
