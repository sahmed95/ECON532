function shares_sim= marketshare(ns, n_markets, n_products, sigma, P_opt, delta, nu)
    % Repeating utility for each consumer 
    U_x = delta'; 
    Delta= repelem(U_x,ns,1); 
    
    % Repeating nu for each product 
    Nu = repelem(nu, 1,n_products);
    
    % Repeating P_opt for ns consumers 
    p_opt = repelem(transpose(P_opt),ns,1);
    % Caculating mu
    Mu = sigma*p_opt.*Nu; 
    
    % Calculating choice probabilities 
    exp_u = exp(Delta-Mu);
    denom = (1+sum(exp_u,2)); 
    denom = reshape(denom, [],1);
    choice_prob = exp_u./denom; 
    
    % Calculating shares
    shares_sim = [];
    for i=1:n_markets
        probs = choice_prob((i-1)*ns+1:i*ns, :);
        share = mean(probs,1);
        shares_sim = [shares_sim,share];
    end
    shares_sim = reshape(shares_sim, n_products, n_markets);
end