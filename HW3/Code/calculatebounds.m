function [upper_bound, lower_bound] = calculatebounds(bidders, trans_price, n_vals, grid,Delta)
    phi_L= [];
    phi_U = [];
    Delta_U = 0; 
    Delta_L = Delta;
    for i = 1:length(n_vals)
        n = n_vals(i);
        num_bid = bidders(bidders==n);
        prices = trans_price(bidders==n);
        % G_(n:n)
        G_i_i_U = pricedist(num_bid, prices, grid, Delta_U); 
        % G_(n:n)^(delta)
        G_i_i_L = valuedist(bidders, trans_price, grid, n, Delta_L);
        % Applying the respective phi functions
        phi_U = [phi_U, (G_i_i_U).^(1/n)];  
        phi_L = [phi_L, G_i_i_L];
    end
    
    % Calulating the bounds
    upper_bound = min(phi_U, [],2);
    lower_bound = max(phi_L, [], 2);
end