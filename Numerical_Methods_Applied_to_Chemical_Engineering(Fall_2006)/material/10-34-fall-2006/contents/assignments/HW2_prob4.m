% 10.34 - Fall 2006
% HW Set#2, Problem #4
% Rob Ashcraft - Sept. 11, 2006

% This script uses two other functions: WaterGasShift and WGS_contour
% This takes a vector of inlet reactor temperatures and attempts to solve
% for the steady-state reactor temperature and outlet mole fractions for
% the simple reaction: CO + H2O <=> CO2 + H2
% It then extracts the results at Tin = 700K for the given conditions:
%   x_in = [CO H2O CO2 H2] = [0.2, 0.8, 0, 0] (mole fractions)
%   P = 10 atm, Vreactor = 5 L 

clear; clc;
start_time = cputime;

% define global variables for the constants in the problem
global Vreactor res_time R Rj A Ea dHrxn dSrxn Cp_vec h

P = 10;  % atm
Vreactor = 5;   % Liters
res_time = 1.5;  % seconds
h = 1.2;  % heat tranfer coefficient in Watts/K

R = 0.08206;  % atm-L/mole-K
Rj = 8.314;  % J/mole-K
A = 32;
Ea = 53000;
dHrxn = -41000;
dSrxn = -42;
Cp_vec = [3.5*Rj, 4*Rj, 4*Rj, 3.5*Rj];

% This is the vector of inlet that we want to investigate in order to find
% the best operating inlet Temperature and the resulting conversion
Tin = [500:25:1500]';

% inlet mole fraction values for this simulation
x_in = [0.2;0.8;0;0];

% loop over the temperature vector in order to get the results at each
% temp, also keep track of the number of steps and time on screen
for i=1:length(Tin)
    timein = cputime;
    [x_out(:,i), Treactor(i,1)] = WaterGasShift(P,Tin(i),x_in);
    conversion(i) = (x_in(1) - x_out(1,i))/x_in(1);
    
    step_time = cputime - timein;
    total_time = cputime - start_time;
    step_num = num2str(i);
    disp(['Completed Step Number ',step_num,' of ',num2str(length(Tin))]);
    disp(['Step Time (s): ',num2str(step_time)]);
    disp(['Total Time (s): ',num2str(total_time)]);
    disp('  ');
    
end

% extract the data for Tin = 700 K to report as asked for in the HW
loc_700 = find(Tin == 700);
x_out_700 = x_out(:,loc_700);
Treactor_700 = Treactor(loc_700);

disp('  ');
disp('Results for Inlet Temperature = 700 K');
disp(['Reactor Temperature = ',num2str(Treactor_700),' K']);
disp(['Outlet Mole Fraction of CO = ',num2str(x_out_700(1))]);
disp(['Outlet Mole Fraction of H2O = ',num2str(x_out_700(2))]);
disp(['Outlet Mole Fraction of CO2 = ',num2str(x_out_700(3))]);
disp(['Outlet Mole Fraction of H2 = ',num2str(x_out_700(4))]);
disp('  ');


%determine the maximum conversion of CO and the operating conditions
[max_conv,loc] = max(conversion);
Tin_conv_max = Tin(loc);
Treactor_conv_max = Treactor(loc);

disp('Operating Condition to Achieve Maximum CO conversion for the current conditions');
disp(['Inlet Temperature = ',num2str(Tin_conv_max),' K']);
disp(['Reactor Temperature = ',num2str(Treactor_conv_max),' K']);
disp(['Maximum Conversion of CO = ',num2str(max_conv*100),' %']);
disp(['Outlet Mole Fraction of H2O = ',num2str(x_out_700(2))]);
disp('  ');

% Plot various figures of interest
figure;
plot(Tin,conversion);
xlabel('Inlet Temperature (K)'); ylabel('CO Conversion Fraction');

figure;
plot(Treactor,conversion);
xlabel('Reactor Temperature (K)'); ylabel('CO Conversion Fraction');

figure;
plot(Tin,Treactor-Tin,'-',[500 1500],[0 0],':');
xlabel('Inlet Temperature  (K)'); ylabel('T_R_e_a_c_t_o_r - T_I_n_l_e_t  (K)');

% This part was not required by the problem, but is an interesting way to
% look at a 2-D problem.
%
% Look at the problem graphicly, by plotting contours of the residual
% equations.  The solution(s) will be where the zero contours intersect

T_in = 700;  % arbitrary inlet temperatue for this case

% specify a grid size.  creates an N x N grid of Treactor and z points at
% which to evaluate the residual equations.  The results will be a matrix
% that can be plotted as a surface of contour plot.  
gridsize = 200; 
n_CO_in = x_in(1)*P*Vreactor/0.08206/T_in;
z_vec = linspace(0,n_CO_in*1.5,gridsize);
Tr_vec = linspace(500,3*T_in,gridsize);

WGS_contour(z_vec,Tr_vec,P,T_in,x_in);
