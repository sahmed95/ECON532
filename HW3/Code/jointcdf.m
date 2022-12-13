function F_U = jointcdf(v, values,n,L)
    ind_sum = 0;
    for l =1:L
        indic = sum(values(l,:)<=v); 
        % if values_i<v_i for all i
        if indic == n
            ind_sum = ind_sum +1; 
        end 
    end 
    F_U = (1/L)*ind_sum;
end
