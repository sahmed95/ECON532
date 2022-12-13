function profit = calculate_profit(theta, ns, n_markets, n_products, P_opt, nu, sigma, delta)
    % Function to calculate profit 
    
    % Caculating derivative terms 
    derivative = calculate_derivative(theta, ns, n_markets, n_products, P_opt, nu, sigma, delta);
    % Calculating simulated market shares 
    shares_sim = marketshare(ns, n_markets, n_products, sigma, P_opt, delta, nu);

    % Extracting own price derivatives   
    own_derivatives =  zeros(n_products, n_markets); 
    for i = 1:n_products
        for j=1:n_markets 
            own_derivatives(i,j) = derivative(n_products*(j-1)+i, i); 
        end 
    end 
    own_derivatives = reshape(own_derivatives, n_products*n_markets, 1);
    Delta_jr = zeros(n_products*n_markets, n_products*n_markets); 
    
    for i=1:n_products*n_markets 
        Delta_jr(i,i) = own_derivatives(i); 
    end 

    markup = -1*Delta_jr\(reshape(shares_sim,[],1));
    markup = reshape(markup, n_products, n_markets);
    
  
    % Calculating profit 
    Profit = zeros(n_products, n_markets);
    for j = 1:n_products
        for m = 1:n_markets
            Profit(j,m)= markup(j,m)*shares_sim(j,m)*ns;
        end
    end
    
    % Reshaping profit 
    profit = reshape(Profit, n_products*n_markets,1); 

end 