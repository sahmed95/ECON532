function f_v = GPVpdf(private_vals,v_grid, all_bids)    
    % Number of bids after trimming
    IL_T = length(private_vals);
    
    % Standard deviation of pseudo private values 
    sigma_v = std(private_vals);

    % Bandwidth
    h_f = 1.06*sigma_v*((IL_T)^(-1/5));
    
    % Total number of bids
    total_bids = length(all_bids);
    
    % Intializing pdf of private values
    f_v = zeros(length(v_grid), 1);
    
    for i=1:length(v_grid)
        add = 0; 
        for j= 1:length(private_vals)
            arg = (v_grid(i)-private_vals(j))/(h_f);
            add = add+triweight(arg);
        end 
        f_v(i) = (1/(total_bids*h_f))*add;
    end
end