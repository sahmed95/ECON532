function derivative = calculate_derivative(theta, ns, n_markets, n_products, P_opt, nu,sigma, delta)
    % Function to calculate derivative of shares with respect to price 
    
    U_x = delta'; 
    Delta= repelem(U_x,ns,1); 

    %Repeating nu for each product 
    Nu = repelem(nu, 1,n_products);

    % Repeating P_opt for ns consumers 
    p_opt = repelem(transpose(P_opt),ns,1);
    
    % Caculating mu
    Mu = sigma*p_opt.*Nu; 

    % Alpha
    alpha = -1*theta(4);
    
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
    
    cross_share = [];
    for i=1:length(choice_prob)
        val = reshape(choice_prob(i,:),[],1)*reshape(choice_prob(i,:),1,[]); 
        cross_share = [cross_share; val]; 
    end 

    identity = repmat(eye(n_products), ns*n_markets,1);
    own_share= repelem(choice_prob, n_products, 1).*identity; 
    
    % Common derivative term 
    alp_sig_nu = alpha+sigma*reshape(nu, [], 1); 
    alp_sig_nu_mat = repelem(alp_sig_nu,n_products,1); 
    
    % Constructing the elasticity matrix 
    elasticity_matrix = alp_sig_nu_mat.*(cross_share-own_share);
  
    % Calculating the derivative 
    derivative = [];
    for i = 1:n_markets
        lower_val= (i-1)* n_products* ns+1;
        upper_val = (i) * n_products * ns;
        elasticity_m = elasticity_matrix(lower_val:upper_val,:);
        val1 = [];
        val2 = [];
        val3 = [];
        for j=1:ns
            prod1 =  elasticity_m(n_products*(j-1)+1:n_products*j,1);
            prod2 =  elasticity_m(n_products*(j-1)+1:n_products*j,2);
            prod3 = elasticity_m(n_products*(j-1)+1:n_products*j,3);
            val1 = [val1,prod1]; 
            val2 = [val2, prod2];
            val3 = [val3, prod3];
        end
        avg_val1 = mean(val1,2);
        avg_val2 = mean(val2,2);
        avg_val3 = mean(val3, 2); 
        avg = [avg_val1, avg_val2, avg_val3];
        derivative = [derivative; avg];
    end
end 