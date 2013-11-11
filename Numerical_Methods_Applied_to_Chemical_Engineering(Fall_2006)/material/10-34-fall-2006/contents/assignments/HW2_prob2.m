% 10.34 - Fall 2006
% HW Set#2, Problem #2
% Rob Ashcraft - Sept. 11, 2006

% This script uses several function that were written as part of this
% problem: Cv_CO2_poly, Cv_CO2_Pade.  These function also require:
% calc_poly_coef and calc_Pade_coef.  The Cv function take in a vector of T
% values (T_vec) at which to return Cv value, as well as a two data vectors with
% Cv_data(T_data) and T_data.  The data is fit using the calc_.._coef
% functions and the resulting expression is evaluated at the T_vec values
% passed to the function.

clear; clc;

% Create the vector where the Cv value will be evaluated
T_vec = linspace(0,3000,100)';

R = 1.987;   % gas constant in cal/mole-K

Cv_inf = 6.5*R;  % this is the specified Cv at infinite temperature

% Given the following T (unscaled) and Cv data:
disp('%%% Calculation for x = T (unscaled) ----------------');
disp('  ');
% Temperature vector in Kelvin which corresponds to the Cv data to come
T_data = [300; 600; 900; 1200];    % T in Kelvin
Cv_data = [6.91; 9.32; 10.68; 11.48];  % in cal/mole-K

% Calculate the Cv for T_vec of polynomial
Cv_T_poly = Cv_CO2_poly(T_vec,T_data,Cv_data);

% Calculate the Cv for T_vec of Pade form
Cv_T_Pade = Cv_CO2_Pade(T_vec,T_data,Cv_data,Cv_inf);


% The problem also asked to do the fitting for a scaled temperature
% Do the fitting for x = T/1000
disp('  ');
disp('  ');
disp('%%% Calculation for x = T/1000 (scaled) ----------------');
disp('  ');
T_vec_scaled = linspace(0,3000,100)'/1000;

T_data_scaled = [300; 600; 900; 1200]/1000;

% Calculate the Cv for scaled T_vec of polynomial form
Cv_T_poly_scaled = Cv_CO2_poly(T_vec_scaled,T_data_scaled,Cv_data);


% Part E: Do the stuff for new T_data vector (Cv was the same)
disp('  ');
disp('  ');
disp('%%% Calculation for Part E: new T_data vector ----------------');
disp('  ');

T_data_E = [300; 600; 900; 2200];

% Calculate the Cv for T_vec of polynomial form for new T_data
Cv_T_poly_E = Cv_CO2_poly(T_vec,T_data_E,Cv_data);%,N_order);

% Calculate the Cv for T_vec of Pade form
Cv_T_Pade_E = Cv_CO2_Pade(T_vec,T_data_E,Cv_data,Cv_inf);


% Now plot the pertinent figures showing the interpolation and
% extrapolation abilities of the two forms.
% Generate the figures for the various parts of the Problem:
figure;        
plot(T_data,Cv_data,'o',T_vec,Cv_T_poly,'--',T_vec,Cv_T_Pade,'-.',T_vec,Cv_inf*ones(length(T_vec)),'-')
legend('Expt. Cv Data','Polynomial Estimate','Pade form estimate','Cv Infinity','Location','SouthEast');
title('Interpolation/Extrapolation Behavior of the Two Forms - Part C');
xlabel('Temperature   [K]'); ylabel('C_v Estimate  [cal/mole-K]');
axis([T_vec(1) T_vec(end) 0 30]);

figure; 
plot(T_data,Cv_data,'o',T_vec,Cv_T_poly,'--',T_vec,Cv_T_Pade,'-.',T_vec,Cv_inf*ones(length(T_vec)),'-')
legend('Expt. Cv Data','Polynomial Estimate','Pade form estimate','Cv Infinity','Location','SouthEast');
title('Interpolation Behavior of the Two Forms - Part C');
xlabel('Temperature   [K]'); ylabel('C_v Estimate  [cal/mole-K]');
axis([T_data(1) T_data(end) 6 14]);

figure;        
plot(T_data_E,Cv_data,'o',T_vec,Cv_T_poly_E,'--',T_vec,Cv_T_Pade_E,'-.',T_vec,Cv_inf*ones(length(T_vec)),'-')
legend('Expt. Cv Data','Polynomial Estimate','Pade form estimate','Cv Infinity','Location','SouthEast');
title('Behavior of the Two Forms with New T_data Vector- Part E');
xlabel('Temperature   [K]'); ylabel('C_v Estimate  [cal/mole-K]');
axis([T_vec(1) T_vec(end) 0 30]);



