% Shabab Ahmed 
% ECON 532 HW 3
%%
%--------------------------------------------------------------------------
% Problem 1:  Distribution of valuations
%--------------------------------------------------------------------------
clear; 
load ascending_data.dat
trans_price = ascending_data(:,2); 
bidders = ascending_data(:,1);


% Creating a grid of transaction prices/values
max_price = 150;
min_price = 0; 
space = 0.01; 
grid = (min_price:space:max_price);


% No bid increment
Delta = 0;

% Value distribution
value_cdf_3 = valuedist(bidders,trans_price, grid,3,Delta);
value_cdf_4 = valuedist(bidders,trans_price, grid,4, Delta);
value_cdf_5 = valuedist(bidders,trans_price, grid, 5,Delta);
value_cdf = [value_cdf_3, value_cdf_4, value_cdf_5];
value_cdf_all = mean(value_cdf,2);

% Plot 
figure(1)
plot(grid, value_cdf_3)
hold on
plot(grid, value_cdf_4)
hold on 
plot(grid, value_cdf_5)
hold on
plot(grid, value_cdf_all)
title('Estimated Distribution of Private Values')
legend('3 Bidders','4 Bidders', '5 Bidders', 'All bidders')
xlabel('v')
ylabel('F^{hat}(v)')
%%


