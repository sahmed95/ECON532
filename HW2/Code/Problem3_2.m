%%
%--------------------------------------------------------------------------
% Problem 3.2 (a) : 
%--------------------------------------------------------------------------
clear; 
load 100markets3products.mat;
% Number of products and number of markets
n_markets = 100;
n_products = 3; 

% Number of consumers 
ns = 500;

%% True marginal costs 
% True parameters
gamma_0 = 2; 
gamma_1 = 1; 
gamma_2 = 1;
beta = [5;1;1];
alpha = 1; 
sigma_alph = 1; 

% Reshaping 
W = reshape(w, n_products, n_markets);
Eta = reshape(eta, n_products, n_markets);
z = reshape(Z, n_products, n_markets);

% Marginal cost
MC_jm = zeros(n_products, n_markets); 
for j = 1:n_products
    for m=1:n_markets
        MC_jm(j,m) = gamma_0+gamma_1*W(j,1)+gamma_2*z(j,m)+Eta(j,m); 
    end
end

mean_MC = mean(MC_jm,"all");
median_MC = median(MC_jm, "all");

figure(1)
mc = histogram(MC_jm);
title('True marginal costs')
xlabel('Marginal costs')
ylabel('Frequency')
saveas(mc ,'mc.png')

%% Marginal costs under Perfect Competition 
MC_pc = P_opt; 
mean_MC_pc = mean(MC_pc, "all");
median_MC_pc = median(MC_pc, "all");

figure(2)
mc_pc = histogram(MC_pc);
title('Distribution of marginal costs under perfect competition')
xlabel('Marginal costs')
ylabel('Frequency')
saveas(mc_pc ,'mc_pc.png')

%% Marginal costs under Oligopoly 
load theta_preferred.mat
load nu_preferred.mat
theta = theta_final;
sigma =theta_final(5);
delta = meanutility(ns, n_markets, n_products, sigma, P_opt, nu, shares);
shares_sim = marketshare(ns, n_markets,n_products, sigma, P_opt, delta, nu);
derivative = calculate_derivative(theta,ns, n_markets, n_products,P_opt, nu, sigma, delta);
markup_olig = calculate_markup_olig(n_products, n_markets, derivative, shares_sim);
mc_olig = P_opt-markup_olig; 
mean_mc_olig = mean(mc_olig, 'all');
median_mc_olig = median(mc_olig, 'all');

figure(3)
MC_olig = histogram(mc_olig);
title('Distribution of marginal costs under oligopoly')
xlabel('Marginal costs')
ylabel('Frequency')
saveas(MC_olig ,'mc_olig.png')

%% Marginal costs under collusion
markup_col = calculate_markup_col(n_products, n_markets, derivative, shares_sim);
mc_col = P_opt-markup_col; 
mean_mc_col = mean(mc_col, 'all');
median_mc_col = median(mc_col, 'all');

figure(4)
MC_col = histogram(mc_col);
title('Distribution of marginal costs under collusion')
xlabel('Marginal costs')
ylabel('Frequency')
saveas(MC_col ,'mc_col.png')
%%