function theta = parameters(delta, X, P_opt, Z)
    W = Z'*Z;
    X_all = [X, reshape(P_opt, [],1)]; 
    prod1_1= X_all'*Z;
    prod1_2 = W\Z'*X_all;
    prod1 = prod1_1*prod1_2;
    prod2_1= X_all'*Z;
    prod2_2 = W\Z'*reshape(delta, [],1);
    prod2 = prod2_1*prod2_2;
    theta = prod1\prod2; 
end 

