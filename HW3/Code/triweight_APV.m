function kernel = triweight_APV(u)
    indicator = ones(length(u),1);
    for i = 1:length(u)
        magnitude = abs(u(i)); 
        if magnitude >1
            indicator(i) = 0;
        end
    end 
    kernel = (35/32)*((1-u.^2).^3).*indicator; 
end 