function bounds = trimming_apv(all_bids)
    % Max bid
    max_B = max(all_bids);

    % Total number of bids 
    total_bids = length(all_bids);

    % Estimated standard deviations of observed bids 
    sigma_b = std(all_bids);

    % Bandwidth
    h_g = 2.978*1.06*sigma_b*((total_bids)^(-1/10));
    
    % Trimming
    lower_bound = h_g;
    upper_bound = max_B-h_g;

    bounds = [lower_bound, upper_bound];

end