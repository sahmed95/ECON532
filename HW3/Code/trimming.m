function bounds = trimming(all_bids)
    % Max and min bids
    max_B = max(all_bids);
    min_B = min(all_bids);
    
    % Length of the support of K
    rho_g = 2;
    
    % Total number of bids 
    total_bids = length(all_bids);

    % Estimated standard deviations of observed bids 
    sigma_b = std(all_bids);

    % Bandwidth
    h_g = 1.06*sigma_b*((total_bids)^(-1/5));
    
    % Trimming 
    val = (rho_g*h_g)/2;
    lower_bound = min_B+val;
    upper_bound = max_B-val;

    bounds = [lower_bound, upper_bound];

end