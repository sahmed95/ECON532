function kernel = triweight(u)
    magnitude = norm(u); 
    indicator = 1; 
    if magnitude >1
        indicator = 0;
    end 
    kernel = (35/32)*((1-u^2)^3)*indicator; 
end 
