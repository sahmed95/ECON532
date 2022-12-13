function G_tilde = calculateG_APV(B,B_i,b,all_bids,h_G,denom_G)
    kernel = triweight_APV((b-all_bids)/h_G); 
    indicator = B_i <= B;
    G_tilde = (1/denom_G)*sum(indicator.*kernel);
end