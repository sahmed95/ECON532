function values_qt = quantilevals(fpa, B_i, all_bids, h_G, h_g, denom_G, denom_g,n)
    % 25th percentile of values 
    values_25 = zeros(n,1);
    
    % 75th percentile of values 
    values_75 = zeros(n,1);
    
    for k=1:n
        bids = fpa(:,k); 
        % Using 25th percentile of bids
        bids_25 = prctile(bids, 25);
        values_25(k) = pseudovalue_APV(bids_25, B_i, all_bids, h_G, h_g, denom_G, denom_g);
        % Using 75th percentile of bids
        bids_75 = prctile(bids, 75);
        values_75(k) = pseudovalue_APV(bids_75, B_i, all_bids, h_G, h_g, denom_G, denom_g); 
    end    
    values_qt = [values_25, values_75];
end
