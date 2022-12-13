% Shabab Ahmed 
% 532 Problem Set 1
%%
% Problem 1: OLS

% Reading the data 
data = readtable('airline.txt');

% Constructing the dependent variable y
y =data(:,1);
y = table2array(y);

% Extracting explanatory variables from the data 
dist = data(:,4); % distance
dep_delay = data(:,3);  % departure delay
dist= table2array(dist); 
dep_delay = table2array(dep_delay);

% Dealing with day fixed effects
days = data(:,2);
days = table2array(days);

% Converting day fixed effects into a categorical variable
day_fe = categorical(days);

% Creating dummy variables for the categorical variable 
dummy = dummyvar(day_fe);

% Removing Day 1 fixed effects to run the regression 
dummy(:,1) = [];

% Creating a vector for the constant term 
const = ones(length(y),1);

% Creating the explanatory variable matrix X 
X = [const, dist, dep_delay dummy];

% Initial guess for MATLAB optimizer (all zeros)
beta_0 = zeros(9,1);

% Objective function to be optimized (sum of squared errors)
obj_func = @(beta) norm(y-X*beta)^2;

% Optimizing using fminsearch 
beta_hat = fminsearch(obj_func, beta_0);

% Analytical solution
beta_ols = (transpose(X)*X)\(transpose(X)*y);

% Presenting the results 
variables = {'const'; 'distance'; 'dep_delay'; 'day_of_week_2'; ...
    'day_of_week_3'; 'day_of_week_4'; 'day_of_week_5'; ...
    'day of week_6';'day_of_week_7'};
T = table(variables,beta_hat, beta_ols)

% Calculating sum of squared residuals 
ssr_hat = norm(y-X*beta_hat)^2;
ssr_ols = norm(y-X*beta_ols)^2;

% Calculating percentage difference in sum of squared residuals
diff = (ssr_hat-ssr_ols)/ssr_ols*100
%%

% Problem 2: Maximum Likelihood

% Initialzing the binary variable to all zeros
I_15 = zeros(length(y),1);

for i =1:length(I_15)
    % set value equal to 1 if flight arrival more than 15 mins late 
    if y(i)>15
        I_15(i) = 1;
    end
end

% Creating explanatory variable matrix X
X = [const, dist, dep_delay];
XB = @(beta) X*beta;

% log likelihood function
log_l = @(beta) sum(I_15.*XB(beta) - log(1+exp(XB(beta))));

% Objective function to be minimized 
obj_func_L = @(beta) -1*log_l(beta); 

% Initial guess (all zeros)
beta_0 = zeros(3,1);

% Optimizing using fminsearch 
beta_hat_mle = fminsearch(obj_func_L, beta_0);

% Presenting the results 
variables = {'const'; 'distance'; 'dep_delay'};
T = table(variables,beta_hat_mle)
%%
% Problem 3: GMM

% Loading the data 
load IV.mat

% Number of data points 
n = length(Y);

% First-step weighting matrix 
W = eye(4); 

% Calculating g_n
g_n = @(beta) (1/n)*(transpose(Z)*Y-transpose(Z)*X*beta);

% Using the g_n to compute the objective function 
obj_func= @(beta) transpose(g_n(beta))*W*g_n(beta);

% Initial guess 
beta_0 = zeros(3,1);

% First stage estimator 
beta_hat_1 = fminsearch(obj_func,beta_0); 

% Residuals of first stage estimator 
eps_hat_1 = Y-X*beta_hat_1; 

% Calculating the covariance matrix
G = (1/n)*transpose(Z)*X;
% Calculating omega 
n_Omega = zeros(4,4);
for i =1:n
    val = eps_hat_1(i)^2*transpose(Z(i,:))*Z(i,:);
    n_Omega = n_Omega+val; 
end
Omega = (1/n)*n_Omega;
GWG = transpose(G)*W*G;  % calculates G'WG
GW = transpose(G)*W;   % calculates G'W
V_1 = inv(GWG)*GW*Omega*W*G*inv(GWG); % covariance matrix

% Standard errors for 1st stage estimator
se_1 = zeros(3,1);
for i=1:3
    se_1(i) = sqrt((1/n)*V_1(i,i));
end

% Presenting the results 
T_1 = table(beta_hat_1, se_1)

% New weighting matrix 
W_hat = inv(Omega);

% New objective function
obj_func_2 = @(beta) transpose(g_n(beta))*W_hat*g_n(beta);
beta_hat_2 = fminsearch(obj_func_2,beta_0); 

% Residuals of second stage estimator 
eps_hat_2 = Y-X*beta_hat_2; 

% Calculating the covariance matrix
G = (1/n)*transpose(Z)*X;
n_Omega_2 = zeros(4,4);
for i =1:n
    val = eps_hat_2(i)^2*transpose(Z(i,:))*Z(i,:);
    n_Omega_2 = n_Omega_2+val; 
end
Omega_2 = (1/n)*(n_Omega_2); 
G_W_hat_G = transpose(G)*W_hat*G;  % calculates G'W_hatG
G_W_hat = transpose(G)*W_hat;   % calculates G'W_hat
V_2 = inv(G_W_hat_G)*G_W_hat*Omega_2*W_hat*G*inv(G_W_hat_G); % covariance matrix

% Direct calculation 
V_2_direct = inv(G_W_hat_G);

% Standard errors for 2nd stage estimator
se_2 = zeros(3,1);
for i=1:3
    se_2(i) = sqrt((1/n)*V_2(i,i));
end

% Presenting the results 
variables_2 = {'estimate'; 'standard error'};
T_2 = table(beta_hat_2, se_2)