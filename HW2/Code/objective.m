function gmm = objective(ns, n_products, n_markets,sigma,nu, P_opt,X,Z,shares)
    delta = meanutility(ns, n_markets, n_products, sigma, P_opt, nu,shares);
    theta = parameters(delta, X, P_opt, Z);
    X_all = [X, reshape(P_opt, [],1)]; 
    X_theta = X_all*theta; 
    xi_hat = reshape(delta, [],1)-X_theta;
    W = Z'*Z;
    gmm_1 = xi_hat'*Z;
    gmm_2 = W\Z'*xi_hat; 
    gmm_2 = Z'*xi_hat; 
    gmm = gmm_1*gmm_2;
end 