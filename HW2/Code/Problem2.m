% Shabab Ahmed 
% ECON 532 HW 2
%%
%--------------------------------------------------------------------------
% Problem 2.1 (a) : Moments for (J,M) = (3,100)
%--------------------------------------------------------------------------
clear; 
load 100markets3products.mat;
% Number of products and number of markets
n_markets = 100;
n_products = 3; 

% Number of consumers 
ns = 500;

% Repeating xi_all
xi_rep = repmat(xi_all, 1,3); 

% Reshaping P_opt
price = reshape(P_opt, n_products*n_markets, 1);

% Reshaping xi
xi = reshape(xi_all, n_products, n_markets);

% E[xi*X]
xi_x = xi_rep.* x1; 
E_xi_x = mean(xi_x); 

% E[xi*p]
xi_p = xi_all.*price; 
E_xi_p = mean(xi_p);

% Calculating p_bar 
p_bar = zeros(n_products, n_markets); 
for i=1:n_markets
    P = P_opt;
    P(:,i) = [];
    p_bar(:,i) = mean(P, 2); 
end 

% Reshaping p_bar
P_bar= reshape(p_bar, n_products*n_markets, 1);


% E[xi*pbar]; 
xi_pbar = xi_all.*P_bar;
E_xi_pbar = mean(xi_pbar);

%%
%--------------------------------------------------------------------------
% Problem 2.2 (c) : Estimation of theta
%--------------------------------------------------------------------------
% Getting the instruments 
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


% For 2(e): Incorrect assumption 
price = reshape(P_opt', n_products*n_markets,1); 
Z_incorrect = [Z_inst, price];

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

%Standard errors
X = x1;
se = standarderror(theta_final, n_products, ns, n_markets, nu, shares, Z_inst, delta, X, P_opt); 

%% Incorrect specification
rng(111)
nu_incorrect = lognrnd(0,1,ns*n_markets, 1); 
gmm_incorrect = @(sig) objective(ns, n_products, n_markets,sig,nu_incorrect, P_opt,X,Z_incorrect,shares);
sigma_incorrect = fminsearch(gmm, sig_0);
delta_incorrect = meanutility(ns, n_markets, n_products, sigma_incorrect, P_opt, nu_incorrect,shares);
theta_incorrect= parameters(delta_incorrect, X, P_opt, Z_incorrect); 
theta_final_incorrect = [theta_incorrect; sigma_incorrect]; 
bias_incorrect = theta_final_incorrect-true; 

% Standard errors 
se_incorrect = standarderror(theta_final_incorrect, n_products, ns, n_markets, nu_incorrect, shares, Z_incorrect, delta_incorrect, X, P_opt); 

%% Stability (try different starting values of sigma)
rng(2022)
sig_0_vec = [0,0.5,1,1.5,2,2.5,3,4,5]; 
thetas = zeros(5, length(sig_0_vec)); 
nu_i = lognrnd(0,1,ns*n_markets, 1); 
gmm_i = @(sig) objective(ns, n_products, n_markets,sig,nu_i, P_opt,X,Z_inst,shares);
for i = 1:length(sig_0_vec)
    sigma_i = fminsearch(gmm_i, sig_0_vec(i));
    delta_i = meanutility(ns, n_markets, n_products, sigma_i, P_opt, nu_i,shares);
    theta_i = parameters(delta_i, X, P_opt, Z_inst); 
    thetas(1:4, i) = theta_i; 
    thetas(5, i) = sigma_i; 
end 

% Standard errors
se_stab= zeros(5,1);
for i = 1:5
    theta_vals = thetas(i, :);
    se_stab(i) = std(theta_vals); 
end 
%%
%--------------------------------------------------------------------------
% Problem 2.2 (d) : Elasticity
%--------------------------------------------------------------------------
elasticity = calculate_elasticity(theta, ns, n_markets, n_products, P_opt, nu, sigma, delta);
% Calculating percentage of firms with own inelastic demands
own_elasticity = elasticity .* repmat(eye(n_products), n_markets, 1);
own_elasticity(own_elasticity == 0) = []; 
inelastic = find(abs(own_elasticity)<1); 
frac_inelastic = length(inelastic)/length(own_elasticity)*100; 

% Median elasticity 
median_elasticity = medianelasticity(theta, ns, n_markets, n_products, P_opt, nu, sigma, delta);

%%
%--------------------------------------------------------------------------
% Problem 2.2 (d) :Profits 
%--------------------------------------------------------------------------
profit = calculate_profit(theta,ns,n_markets,n_products, P_opt, nu, sigma, delta); 

figure(1)
profit_dist_2d = histogram(profit);
title('Distribution of Profits for 100 markets and 3 products (demand instruments)')
xlabel('Profit')
ylabel('Frequency')
saveas(profit_dist_2d ,'profit_dist_2d.png')

med_profit = median(profit); 
mean_profit = mean(profit);
%%
%--------------------------------------------------------------------------
% Problem 2.2 (d) :Consumer Surplus
%--------------------------------------------------------------------------
CS = csurplus(ns, n_markets, delta, P_opt, nu, sigma);

figure(2)
cs_dist_2d = histogram(CS);
title('CS Distribution (100 markets, 3 products)')
xlabel('Consumer Surplus')
ylabel('Markets')
saveas(cs_dist_2d ,'cs_dist_2d.png')

med_cs = median(CS);
mean_cs = mean(CS); 
%%
%--------------------------------------------------------------------------
% Problem 2.2 (e) : M = 10
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

%% Estimation 

% Fixed draw of consumers 
rng(11)
nu = lognrnd(0,1,ns*n_markets, 1); 
gmm = @(sig) objective(ns, n_products, n_markets,sig,nu, P_opt,X,Z_10,shares);
sig_0 = 1; 
sigma_10= fminsearch(gmm, sig_0);
delta_10 = meanutility(ns, n_markets, n_products, sigma_10, P_opt, nu,shares);
theta_10 = parameters(delta_10, X, P_opt, Z_10); 
theta_final_10 = [theta_10; sigma_10]; 
%%
se_10 = standarderror(theta_final_10, n_products, ns, n_markets, nu, shares, Z_10, delta_10, X,P_opt);
true = [5;1;1;-1;1];
bias_10 = theta_final_10 - true;
%% Stability (try different starting values of sigma)
sig_0_vec = [0,0.5, 1,1.5,2,2.5,3,4,5]; 
thetas_10 = zeros(5, length(sig_0_vec)); 
for i = 1:length(sig_0_vec)
    sigma_i = fminsearch(gmm, sig_0_vec(i));
    delta_i = meanutility(ns, n_markets, n_products, sigma_i, P_opt, nu,shares);
    theta_i = parameters(delta_i, X, P_opt, Z_10); 
    thetas_10(1:4, i) = theta_i; 
    thetas_10(5, i) = sigma_i; 
end 
se_stab_10= zeros(5,1);
for i = 1:5
    theta_vals = thetas_10(i, :);
    se_stab_10(i) = std(theta_vals); 
end 
