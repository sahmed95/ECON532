function CS = csurplus(ns, n_markets, delta, P_opt, nu, sigma)
        
    % Euler constant 
    u = 0.5772;
    
    % Repeating utility for each consumer 
    U_x = delta'; 
    Delta= repelem(U_x,ns,1); 
    
    % Alpha_i
    alpha_i = sigma*nu; 
    
    
    % Repeating P_opt for ns consumers 
    p_opt =  repelem(P_opt', ns,1);
    
    % Utility for all consumers for all products in every market 
    Util = Delta-alpha_i.*p_opt;
    
    % Calculating Consumer Surplus 
    exp_u = exp(Util); 
    sum_exp_u = sum(exp_u,2);
    log_sum = log(sum_exp_u);
    cs = (u+log_sum)./alpha_i; 
    
    % Accounting for outside option 
    cs(cs<0) = 0; 
    
    % Consumer surplus
    cs_re = reshape(cs, ns,n_markets);
    CS = mean(reshape(cs_re', n_markets, ns),2);


end