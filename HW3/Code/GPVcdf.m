function F_v = GPVcdf(private_vals, v_grid)
    num_values = length(private_vals);
    F_v = zeros(num_values,1);
    for i=1:length(v_grid)
        F_v(i) = (1/num_values)*sum(private_vals<= v_grid(i));
    end 
end 