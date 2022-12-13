function markup_olig= calculate_markup_olig(n_products, n_markets,derivative,shares_sim)
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
    
    markup_olig = -1*Delta_jr\(reshape(shares_sim,[],1));
    markup_olig = reshape(markup_olig, n_products, n_markets);
end