% Shabab Ahmed 
% ECON 532 HW 3
%%
%--------------------------------------------------------------------------
% Problem 3 (b):  FPA with SIPV
%--------------------------------------------------------------------------
clear; 
load fpa.dat;

% Putting all the bids together
all_bids = reshape(fpa, [],1);

% Creating a grid for bids/values
b_grid = sort(all_bids);
%%
private_vals = pseudovalue(all_bids, b_grid);

% Creating a grid for private values 
max_v = max(private_vals);
min_v = min(private_vals);
space = 0.01; 
v_grid = (min_v:space:max_v)';
% PDF of private values 
f_v = GPVpdf(private_vals, v_grid, all_bids);
F_v = GPVcdf(private_vals, v_grid); 


% Plotting PDF
figure(1)
plot(v_grid, f_v)
title('GPV PDF of Private Values (SIPV)')
xlabel('v')
ylabel('f^{hat}(v)')

% Plotting CDF
figure(2)
plot(v_grid, F_v)
title('GPV CDF of Private Values (SIPV)')
xlabel('v')
ylabel('F^{hat}(v)')

