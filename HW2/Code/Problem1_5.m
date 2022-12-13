% Shabab Ahmed 
% ECON 532 HW 2
%%
%--------------------------------------------------------------------------
% Problem 1:  Distribution of prices of 100 markets 5 products
%--------------------------------------------------------------------------
clear;
% 100 markets 5 products 
load('100markets5products.mat'); 

% Number of products and number of markets
n_markets = 100;
n_products = 5; 

% Number of consumers 
ns = 500;

% Reshaping price 

price = reshape(P_opt, n_markets*n_products, 1); 

% Distribution of price 

figure(1)
price_dist_5 = histogram(price);
title('Distribution of Prices for 100 markets and 5 products')
xlabel('Price')
ylabel('Frequency')
saveas(price_dist_5 ,'price_dist_5.png')

%%
%--------------------------------------------------------------------------
% Problem 1:  Distribution of profits of 100 markets 5 products
%--------------------------------------------------------------------------
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

% Profit 
profit = zeros(n_products, n_markets);
for j = 1:n_products
    for m = 1:n_markets
        markup = P_opt(j,m)-MC_jm(j,m);
        profit(j,m)= markup*shares(j,m)*ns;
    end
end

% Reshaping profit 
Profit = reshape(profit, n_products*n_markets,1); 

figure(2)
profit_dist_5= histogram(Profit);
title('Distribution of Profits for 100 markets and 5 products')
xlabel('Profit')
ylabel('Frequency')
saveas(profit_dist_5 ,'profit_dist_5.png')
%%
%--------------------------------------------------------------------------
% Problem 1:  Distribution of consumer surplus of 100 markets 5 products
%--------------------------------------------------------------------------
X1 = reshape(x1(:,1), n_products, n_markets); 
X2 = reshape(x1(:,2), n_products, n_markets);
X3 = reshape(x1(:,3), n_products, n_markets); 
xi = reshape(xi_all, n_products, n_markets); 
delta = X1*beta(1)+X2*beta(2)+X3*beta(3)+xi-P_opt;
alphas_re = reshape(alphas', ns*n_markets,1); 
nu = alphas_re-1; 
CS = csurplus(ns, n_markets, delta, P_opt, nu, sigma_alph);


figure(3)
cs_dist_5= histogram(CS);
title('CS Distribution (100 markets, 5 products)')
xlabel('Consumer Surplus')
ylabel('Markets')
saveas(cs_dist_5 ,'cs_dist_5.png')

