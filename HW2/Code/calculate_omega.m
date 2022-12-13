function omega = calculate_omega(P_opt, markup, w_hat, Z_inst)
    mc = P_opt-markup; 
    gamma = calculate_gamma(P_opt,markup, w_hat, Z_inst);
    omega = reshape(mc, [],1) -(w_hat*gamma); 
end