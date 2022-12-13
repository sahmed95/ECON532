function g_tilde = calculategtild_APV(B,B_i, b, all_bids, h_g,denom_g)
    kernel1 = triweight_APV((B-B_i)/h_g);
    kernel2 = triweight_APV((b-all_bids)/h_g); 
    kernel = kernel1.*kernel2; 
    g_tilde = (1/denom_g)*sum(kernel); 
    
end

