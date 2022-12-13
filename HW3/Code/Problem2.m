% Shabab Ahmed 
% ECON 532 HW 3
%%
%--------------------------------------------------------------------------
% Problem 2:  Haile and Tamer (2003)
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

% Number of bidders
n_vals = [3,4,5];

% Minimum bid increment
Delta = 1;

% Getting the bounds 
[upper_bound, lower_bound] = calculatebounds(bidders, trans_price, n_vals, grid, Delta);

% Plot of the bounds
plot(grid, upper_bound)
hold on
plot(grid, lower_bound); 
legend('Upper bound', 'Lower Bound')
title('Estimated Bounds for the CDF of Private Value')
xlabel('v')
ylabel('F^{hat}(v)')

%%