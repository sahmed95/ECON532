%%
%--------------------------------------------------------------------------
% Problem 4.2 (b) : 
%--------------------------------------------------------------------------
clear; 
load 100markets3products.mat;
% Number of products and number of markets
n_markets = 100;
n_products = 3; 

% Number of consumers 
ns = 500;

%% True markup
load theta_best.mat 
load nu_best.mat
theta_final = theta_final_olig; 
theta = theta_final(1:4); 
sigma = theta_final(5); 
delta = meanutility(ns, n_markets, n_products, sigma,P_opt, nu, shares);
markup_matrix = [1,1,0; 1,1,0;0,0,1]; 
sim_shares = marketshare(ns, n_markets, n_products, sigma, P_opt, delta, nu);
derivative = calculate_derivative(theta, ns, n_markets, n_products, P_opt, nu, sigma, delta);
markups = calculate_markup_olig(n_products, n_markets, derivative, sim_shares);
mu_true_avg = mean(markups, 'all');
mu_true_med = median(markups, 'all'); 

figure(1) 
mu = histogram(markups); 
title('Distribution of markups')
xlabel('Markup')
ylabel('Frequency')
saveas(mu, 'mu_true.png')

%%
Delta_jr = zeros(n_products*n_markets, n_products*n_markets);
for i=1:n_markets 
    block = derivative((i-1)*n_products+1:i*n_products,:); 
    Delta_jr((i-1)*n_products+1:i*n_products, (i-1)*n_products+1:i*n_products) = block;
end 
markup_mat = [];
for i=1:n_markets
    markup_mat = [markup_mat; markup_matrix]
end
final_mat = [];
for j=1:n_markets
    final_mat = [final_mat, markup_mat];
end
new_Delta_jr = Delta_jr.*final_mat;
markup_merge = -1*new_Delta_jr\(reshape(sim_shares,[],1));
markup_merge = reshape(markup_merge, n_products, n_markets);

mu_merge_avg = mean(markup_merge, 'all');
mu_merge_med = median(markup_merge, 'all'); 

figure(2) 
mu_merge = histogram(markup_merge); 
title('Distribution of merged markups')
xlabel('Markup')
ylabel('Frequency')
saveas(mu_merge, 'mu_merge.png')

diff_1 = markup_merge(1,:)-markups(1,:);
diff_2 = markup_merge(2,:)-markups(2,:);
diff_3 = markup_merge(3,:)-markups(3,:);

mean_diff_1 = mean(diff_1);
mean_diff_2 = mean(diff_2);
mean_diff_3 = mean(diff_3);

gamma = theta_final_olig(6:8);
w_hat = [ones(n_products*n_markets,1), w, Z]; 
mc = w_hat*gamma; 
price_merged = mc+reshape(markup_merge,[],1);

figure(3) 
p_dist = histogram(price_merged); 
title('Distribution of new prices')
xlabel('Price')
ylabel('Frequency')
saveas(p_dist, 'price_merged.png')
%%
%--------------------------------------------------------------------------
% Problem 4.2 (c) : Consumer surplus
%--------------------------------------------------------------------------
price_merged = reshape(price_merged, n_products, n_markets);
CS = csurplus(ns, n_markets, delta,price_merged, nu, sigma);

mean(CS)
median(CS)
figure(4) 
cs = histogram(CS); 
title('Distribution of merged consumer surplus')
xlabel('Consumer Surplus')
ylabel('Frequency')
saveas(cs, 'cs_merged.png')

%%
%--------------------------------------------------------------------------
% Problem 4.2 (c) : Profits
%--------------------------------------------------------------------------

profit = markup_merge.*sim_shares*ns; 

mean(profit,'all')
median(profit,'all')

figure(5) 
Profit = histogram(profit); 
title('Distribution of merged profits')
xlabel('Profit')
ylabel('Frequency')
saveas(Profit, 'profit_merged.png')