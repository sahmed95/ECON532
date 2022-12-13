% Shabab Ahmed 
% ECON 532 HW 3
%%
%--------------------------------------------------------------------------
% Problem 3 (a):  FPA with SAPV
%--------------------------------------------------------------------------
clear; 
load fpa.dat;

% Number of auctions and bids 
L = length(fpa); 
n = length(fpa(1,:));

% Putting all the bids together
all_bids = reshape(fpa', [],1);

% Max bid
max_B = all_bids;

% Estimated standard deviation of bids
sigma_b = std(all_bids);

% Finding the max 
b_i = all_bids; 
bids_repeat = repelem(fpa,n,1); 
I = repmat(eye(n),L,1);
B_A = bids_repeat - I.*bids_repeat;
% For every block of 4 rows, the ith row is max of the bids other than i
B_i = max(B_A, [],2);

% Bandwidths
h_G = 2.978*1.06*sigma_b*(n*L)^(-1/9); 
h_g = 2.978*1.06*sigma_b*(n*L)^(-1/10);
denom_G = L*n*h_G;
denom_g = L*n*(h_g)^2; 

%%
% Private values
values = zeros(L,n);
for k=1:n
    for i=1:L
        b = fpa(i,k);
        values(i,k)= pseudovalue_APV(b, B_i, all_bids, h_G, h_g, denom_G, denom_g);
    end
end

%% Getting quantiles 
value_qt = quantilevals(fpa, B_i, all_bids, h_G, h_g, denom_G, denom_g, n);
value_25 = value_qt(1); 
value_75 = value_qt(2);

%% Creating the quantile table 
v_16 = [];
for i=1:2
    for j=1:2
        for k=1:2
            for l=1:2
                v_append = [value_qt(1,i), value_qt(2,j), value_qt(3,k), value_qt(4,l)]; 
                v_16 = [v_16; v_append];
            end
        end 
    end 
end 
%% Joint CDF 
F_U_table = zeros(16,1); 
for i=1:16
    F_U_table(i) = jointcdf(v_16(i,:), values, n,L);
end 
