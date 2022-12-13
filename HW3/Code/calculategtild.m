function g_tilde = calculategtild(all_bids, b_grid)
    % Estimated standard deviations of observed bids 
    sigma_b = std(all_bids);
    
    % Total number of bids
    total_bids = length(all_bids);
    
    % Bandwidth
    h_g = 1.06*sigma_b*((total_bids)^(-1/5));
    
    % Initializing g_tilde(b)

    g_tilde = zeros(length(b_grid),1);
    for i=1:length(b_grid)
        sum = 0; 
        for j= 1:length(all_bids)
            arg = (b_grid(i)-all_bids(j))/(h_g);
            sum = sum+triweight(arg);
        end 
        g_tilde(i) = (1/(total_bids*h_g))*sum;
    end
end
