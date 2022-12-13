function markup_col= calculate_markup_col(n_products, n_markets,derivative,shares_sim)
    Delta_jr_col = zeros(n_products*n_markets, n_products*n_markets);
    for i=1:n_markets 
        block = derivative((i-1)*n_products+1:i*n_products,:); 
        Delta_jr_col((i-1)*n_products+1:i*n_products, (i-1)*n_products+1:i*n_products) = block;
    end 
    markup_col= -1*Delta_jr_col\(reshape(shares_sim,[],1));
    markup_col = reshape(markup_col, n_products, n_markets);
end