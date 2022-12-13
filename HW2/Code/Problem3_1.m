% Shabab Ahmed 
% ECON 532 HW 2
%%
%--------------------------------------------------------------------------
% Problem 3.1 (b) : Estimating theta
%--------------------------------------------------------------------------
clear; 
load 100markets3products.mat;
% Number of products and number of markets
n_markets = 100;
n_products = 3; 

% Number of consumers 
ns = 500;

%%
% Instruments 

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

%% Estimation 

% Fixed draw of consumers 
rng(111)
nu = lognrnd(0,1,ns*n_markets, 1); 
gmm = @(sig) objective(ns, n_products, n_markets,sig,nu, P_opt,X,Z_inst,shares);
sig_0 = 1; 
sigma = fminsearch(gmm, sig_0);
delta = meanutility(ns, n_markets, n_products, sigma, P_opt, nu,shares);
theta = parameters(delta, X, P_opt, Z_inst); 
theta_final = [theta; sigma]; 
true = [5;1;1;-1;1]; 
bias = theta_final-true;
% Standared error 
se_cost = standarderror(theta_final, n_products, ns, n_markets, nu, shares, Z_inst, delta, X,P_opt);
save('nu_preferred.mat','nu')
save('theta_preferred.mat', 'theta_final')

%% Elasticity of demand at equilibrium prices 
elasticity = calculate_elasticity(theta, ns, n_markets, n_products, P_opt, nu, sigma, delta);
% Calculating percentage of firms with own inelastic demands
own_elasticity = elasticity .* repmat(eye(n_products), n_markets, 1);
own_elasticity(own_elasticity == 0) = []; 
inelastic = find(abs(own_elasticity)<1); 
frac_inelastic = length(inelastic)/length(own_elasticity)*100; 

% Median elasticity 
median_elasticity = medianelasticity(theta, ns, n_markets, n_products, P_opt, nu, sigma, delta);
%% Profits 

profit = calculate_profit(theta,ns,n_markets,n_products, P_opt, nu, sigma, delta); 

figure(1)
profit_dist_3b = histogram(profit);
title('Distribution of Profits for 100 markets and 3 products with cost shifter')
xlabel('Profit')
ylabel('Frequency')
saveas(profit_dist_3b ,'profit_dist_3b.png')

med_profit = median(profit);
mean_profit = mean(profit); 

%% Consumer Surplus 

CS = csurplus(ns, n_markets, delta, P_opt, nu, sigma);

figure(2)
cs_dist_3b = histogram(CS);
title('CS Distribution with cost shifter (100 markets, 3 products)')
xlabel('Consumer Surplus')
ylabel('Markets')
saveas(cs_dist_3b ,'cs_dist_3b.png')

med_CS = median(CS); 
mean_CS = mean(CS);
%%
%--------------------------------------------------------------------------
% Problem 3.1 (c) : Estimating theta for M=10
%--------------------------------------------------------------------------
clear; 
load 10markets3products.mat;
% Number of products and number of markets
n_markets = 10;
n_products = 3; 

% Number of consumers 
ns = 500;

% Getting the instruments 
X = x1;
Z_10 = zeros(n_markets*n_products, 5);
Z_10(:, 1:3) = X; 
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
Z_10(:,4) = reshape(Z2, n_products*n_markets,1);
Z_10(:,5) = reshape(Z3, n_products*n_markets,1); 
Z_10 = [Z_10, w];

%% Estimation

% Fixed draw of consumers 
rng(111)
nu = lognrnd(0,1,ns*n_markets, 1); 
gmm = @(sig) objective(ns, n_products, n_markets,sig,nu, P_opt,X,Z_10,shares);
sig_0 = 1; 
sigma_10= fminsearch(gmm, sig_0);
delta_10 = meanutility(ns, n_markets, n_products, sigma_10, P_opt, nu,shares);
theta_10 = parameters(delta_10, X, P_opt, Z_10); 
theta_final_10 = [theta_10; sigma_10]; 

% Bias and standard error 
true = [5;1;1;-1;1];
se_10 = standarderror(theta_final_10, n_products, ns, n_markets, nu, shares, Z_10, delta_10, X, P_opt); 
bias_10 = theta_final_10 - true;

%% Stability
rng(111)
nu_i = lognrnd(0,1,ns*n_markets, 1); 
gmm_i = @(sig) objective(ns, n_products, n_markets,sig,nu_i, P_opt,X,Z_10, shares);
sig_0_vec = [0,0.5, 1,1.5,2,2.5,3,4,5]; 
thetas_10 = zeros(5, length(sig_0_vec)); 
for i = 1:length(sig_0_vec)
    sigma_i = fminsearch(gmm, sig_0_vec(i));
    delta_i = meanutility(ns, n_markets, n_products, sigma_i, P_opt, nu_i,shares);
    theta_i = parameters(delta_i, X, P_opt, Z_10); 
    thetas_10(1:4, i) = theta_i; 
    thetas_10(5, i) = sigma_i; 
end 

% Standard errors
se_stab= zeros(5,1);
for i = 1:5
    theta_vals = thetas_10(i, :);
    se_stab(i) = std(theta_vals); 
end
