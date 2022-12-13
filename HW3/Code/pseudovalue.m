function private_vals = pseudovalue(all_bids, b_grid)
    % Calculating G_tilde 
    G_tilde = calculateG(all_bids, b_grid);
    
    % Calculating g_tilde
    g_tilde = calculategtild(all_bids, b_grid);
    
    % Number of bidders
    num_bidders = 4;
    
    % Trimming 
    bounds = trimming(all_bids);
    lower = bounds(1);
    upper = bounds(2);
    
    % Pseudo private values 
    
    private_vals = zeros(length(b_grid),1);
    for i=1:length(b_grid)
        b = b_grid(i); 
        if b>=lower && b<=upper
            G_g = G_tilde(i)/g_tilde(i);
            private_vals(i) = b+(1/(num_bidders-1))*G_g;
        else 
            private_vals(i) = Inf;
        end
    end 

    % Getting rid of infinite values
    private_vals = private_vals(private_vals<Inf);
end