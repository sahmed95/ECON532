function gamma = calculate_gamma(P_opt,markup, w_hat, Z_inst)
    mc = P_opt - markup; 
    mc = reshape(mc, [],1);
    W = Z_inst'*Z_inst;
    prod1_2 = W\Z_inst'; 
    prod1 = Z_inst*prod1_2; 
    prod2_1 = w_hat'*prod1*w_hat; 
    prod2_2 = w_hat'*prod1*mc; 
    gamma = prod2_1\prod2_2;
end