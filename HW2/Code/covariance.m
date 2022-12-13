function V = covariance(W, X, Z, P_op, shares_true, v, ns, n_markets, n_products, theta)
    G = (1/n)*transpose(Z)*X;
    % Calculating omega 
    n_Omega = zeros(4,4);
    for i =1:n
        val = eps_hat_1(i)^2*transpose(Z(i,:))*Z(i,:);
        n_Omega = n_Omega+val; 
    end
    Omega = (1/n)*n_Omega;
    GWG = transpose(G)*W*G;  % calculates G'WG
    GW = transpose(G)*W;   % calculates G'W 
    V = inv(GWG)*GW*Omega*W*G*inv(GWG); 

end 