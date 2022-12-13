function G_tilde = calculateG(all_bids, b_grid)
    % Total number of bids
    total_bids = length(all_bids);
    
    % No bid incremenrs 
    G_tilde = zeros(length(b_grid),1);
    for i=1:length(b_grid)
        G_tilde(i) = (1/total_bids)*sum(all_bids<= b_grid(i));
    end
end
