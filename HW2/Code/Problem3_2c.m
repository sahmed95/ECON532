%%
%--------------------------------------------------------------------------
% Problem 3.2 (c) : 
%--------------------------------------------------------------------------
clear; 
load 100markets3products.mat;
% Number of products and number of markets
n_markets = 100;
n_products = 3; 

% Number of consumers 
ns = 500;

%% Instruments 

X = x1;
Z_inst= zeros(n_markets*n_products, 5);
Z_inst(:, 1:3) = X; 
X2 = reshape(X(:,2), n_products, n_markets);
X3 = reshape(X(:,3), n_products, n_markets);

% calculating the last two instruments 

% For subtracting the jth product characteristics 
x2_1 = X2(1,:);
x2_2 = X2(2,:);
x2_3 = X2(3,:);

x3_1 = X3(1,:);
x3_2 = X3(2,:);
x3_3 = X3(3,:);

% Calculating the sums
z2_1 = sum(X2)-x2_1;
z2_2 = sum(X2)-x2_2;
z2_3 = sum(X2)-x2_3;

z3_1 = sum(X3)-x3_1;
z3_2 = sum(X3)-x3_2;
z3_3 = sum(X3)-x3_3;

% Stacking 
Z2 = [z2_1;z2_2;z2_3]; 
Z3 = [z3_1; z3_2; z3_3]; 

% Adding to the instruments
Z_inst(:,4) = reshape(Z2, n_products*n_markets,1);
Z_inst(:,5) = reshape(Z3, n_products*n_markets,1); 
Z_inst = [Z_inst, w];

% W_hat 
w_hat = [ones(n_products*n_markets,1), w, Z]; 

%% Perfect competition
X = x1;
rng(2022)
nu = lognrnd(0,1,ns*n_markets, 1); 
gmm = @(sig) objective_supply(ns, n_markets,n_products, sig, P_opt, nu, shares, Z, Z_inst,w,X,'pc');
sig_0 = 1; 
sigma = fminsearch(gmm, sig_0);
delta = meanutility(ns, n_markets, n_products, sigma, P_opt, nu,shares);
theta = parameters(delta, X, P_opt, Z_inst); 
markup =zeros(n_products, n_markets);
gamma = calculate_gamma(P_opt, markup,w_hat, Z_inst); 
theta_demand = [theta;sigma];
theta_final = [theta_demand; gamma];
true = [5;1;1;-1;1;2;1;1]; 
bias = theta_final-true; 
se_pc = standarderror(theta_demand,n_products, ns, n_markets, nu, shares,Z_inst, delta, X, P_opt);

%% Elasticity
elasticity = calculate_elasticity(theta, ns, n_markets, n_products, P_opt, nu, sigma, delta);
% Calculating percentage of firms with own inelastic demands
own_elasticity = elasticity .* repmat(eye(n_products), n_markets, 1);
own_elasticity(own_elasticity == 0) = []; 
inelastic = find(abs(own_elasticity)<1); 
frac_inelastic_pc = length(inelastic)/length(own_elasticity)*100; 

% Median elasticity 
median_elasticity_pc = medianelasticity(theta, ns, n_markets, n_products, P_opt, nu, sigma, delta);
%% Oligopoly 
rng(2022)
nu = lognrnd(0,1,ns*n_markets, 1); 
gmm = @(sig) objective_supply(ns, n_markets,n_products, sig, P_opt, nu, shares, Z, Z_inst,w,X,'olig');
sig_0 = 1; 
sigma_olig= fminsearch(gmm, sig_0);
delta_olig= meanutility(ns, n_markets, n_products, sigma_olig, P_opt, nu,shares);
theta_olig = parameters(delta_olig, X, P_opt, Z_inst); 
derivative = calculate_derivative(theta_olig, ns, n_markets, n_products, P_opt, nu, sigma_olig, delta_olig);
shares_sim = marketshare(ns, n_markets, n_products, sigma_olig, P_opt, delta_olig, nu);
markup = calculate_markup_olig(n_products, n_markets, derivative, shares_sim);
gamma_olig= calculate_gamma(P_opt, markup,w_hat, Z_inst); 
theta_demand_olig = [theta_olig;sigma_olig];
theta_final_olig = [theta_demand_olig; gamma_olig];
true = [5;1;1;-1;1;2;1;1]; 
bias = theta_final_olig-true;

% Standard error
se_olig = standarderror(theta_demand_olig,n_products, ns, n_markets, nu, shares,Z_inst, delta_olig, X, P_opt);

% Saving theta
save('theta_best.mat', "theta_final_olig")
save('nu_best.mat', "nu")
%%
%% Elasticity
elasticity = calculate_elasticity(theta_olig, ns, n_markets, n_products, P_opt, nu, sigma_olig, delta_olig);
% Calculating percentage of firms with own inelastic demands
own_elasticity = elasticity .* repmat(eye(n_products), n_markets, 1);
own_elasticity(own_elasticity == 0) = []; 
inelastic = find(abs(own_elasticity)<1); 
frac_inelastic_olig = length(inelastic)/length(own_elasticity)*100; 

% Median elasticity 
median_elasticity_olig = medianelasticity(theta_olig, ns, n_markets, n_products, P_opt, nu, sigma_olig, delta_olig);

%% Collusion 
rng(2000)
nu = lognrnd(0,1,ns*n_markets, 1); 
gmm = @(sig) objective_supply(ns, n_markets,n_products, sig, P_opt, nu, shares, Z, Z_inst,w,X,'olig');
sig_0 = 1; 
sigma_col= fminsearch(gmm, sig_0);
delta_col= meanutility(ns, n_markets, n_products, sigma_col, P_opt, nu,shares);
theta_col = parameters(delta_col, X, P_opt, Z_inst); 
derivative = calculate_derivative(theta_col, ns, n_markets, n_products, P_opt, nu, sigma_col, delta_col);
shares_sim = marketshare(ns, n_markets, n_products, sigma_col, P_opt, delta_col, nu);
markup_col = calculate_markup_col(n_products, n_markets, derivative, shares_sim);
gamma_col= calculate_gamma(P_opt, markup_col,w_hat, Z_inst); 
theta_demand_col = [theta_col;sigma_col];
theta_final_col = [theta_demand_col; gamma_col];
true = [5;1;1;-1;1;2;1;1]; 
bias = theta_final_col-true;

% Standard error
se_col = standarderror(theta_demand_col,n_products, ns, n_markets, nu, shares,Z_inst, delta_olig, X, P_opt);

%% Elasticity
elasticity = calculate_elasticity(theta_col, ns, n_markets, n_products, P_opt, nu, sigma_olig, delta_olig);
% Calculating percentage of firms with own inelastic demands
own_elasticity = elasticity .* repmat(eye(n_products), n_markets, 1);
own_elasticity(own_elasticity == 0) = []; 
inelastic = find(abs(own_elasticity)<1); 
frac_inelastic_col = length(inelastic)/length(own_elasticity)*100; 

% Median elasticity 
median_elasticity_col = medianelasticity(theta_col, ns, n_markets, n_products, P_opt, nu, sigma_col, delta_col);
