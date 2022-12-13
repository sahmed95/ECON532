function private_val = pseudovalue_APV(b, B_i, all_bids, h_G, h_g, denom_G, denom_g)
    G_tilde = calculateG_APV(b, B_i, b, all_bids,h_G,denom_G);
    g_tilde = calculategtild_APV(b, B_i, b,all_bids, h_g, denom_g); 
    G_g = G_tilde/g_tilde; 
    private_val = b+G_g; 
end