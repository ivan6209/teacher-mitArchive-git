% 10.34 - Fall 2006
% HW Set#2, Problem #1
% Rob Ashcraft - Sept. 11, 2006

% This matlab script uses linear regression to determine the parameters in
% the Michaelis-Menten form for given rate data as a function of substratea
% and enzyme concentrations.

clear; clc;

% create the rate data matrix [[S], r([E]o=0.005), r([E]o=0.01)];
% [S] and [E]o are in grams/L
Rate_data =[...
    1.0     0.055       0.108;
    2.0     0.099       0.196;
    5.0     0.193       0.383;
    7.5     0.244       0.488;
    10.0    0.280       0.560;
    15.0    0.333       0.665;
    20.0    0.365       0.733;
    30.0    0.407       0.815];

Eo = [0.005 0.01];   % initial enzyme concentrations

% Extract the substrate concentration vector, piece it together twice so
% all data is together in a single vector
S = [Rate_data(:,1); Rate_data(:,1)];  
Rate = [Rate_data(:,2);Rate_data(:,3)];


%Generate the "y" variable for both Eo values (y = Eo/r)
y_005 = 0.005./Rate_data(:,2);
y_01 = 0.01./Rate_data(:,3);

y_all = [y_005; y_01];

%generate the "x" variable (x = 1/[S])
x = 1./S;

% generate the X matrix for the system
X_mat(:,1) = ones(length(S),1);
X_mat(:,2) = x;

% Use the backslash command to solve the linear regression: X'X*b = X'*y
b = X_mat'*X_mat\X_mat'*y_all;

% Convert the "b" value to meaningful parameters k2 and Km
k2 = 1/b(1);
Km = k2*b(2);

% Display the parameters to the command window
disp(['k2  =  ',num2str(k2),'  g_S/min/g_E']);
disp(['Km  =  ',num2str(Km),'  g_S/L']);
disp('  ');

% generate the fitted-equation predictions for [S]=0 to 30
S_vec = linspace(0,30,300)';
r_pred_005 = (k2*Eo(1)*S_vec)./(Km + S_vec);
r_pred_01 = (k2*Eo(2)*S_vec)./(Km + S_vec);

% Plot the experimental data and predictions from the best fit values
figure;
plot(S,Rate,'o',S_vec,r_pred_005,'--',S_vec,r_pred_01,'-.')
title('10.34 Fall 2006 - HW Set#2, Problem 1');
xlabel('S concentration  [g/L]'); ylabel('Coversion Rate of S  [g_s/L/min]');
legend('Experimental','Fitted - E_0 = 0.005 g_E/L','Fitted - E_0 = 0.01 g_E/L','Location','SouthEast');




