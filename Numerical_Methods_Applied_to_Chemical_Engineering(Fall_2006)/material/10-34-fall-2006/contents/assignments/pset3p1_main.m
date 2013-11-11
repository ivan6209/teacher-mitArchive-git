% 10.34 - Fall 2006
% HW Set#3, Problem #1
% Rob Ashcraft - Sept. 19, 2006

% Calculate the peak temperature for a water-gas shift reactor.  This
% function calculates the peak temperature for complete reaction and for a
% reaction that proceeds to equilibrium.
%   CO + H2O <=> CO2 + H2
function pset3p1_main

clear; clc;

global CH4_coef O2_coef H2_coef H2O_coef CO_coef CO2_coef R Rj V

% Get the Shomate coefficients for the species of interest
[CH4_coef, O2_coef, H2_coef, H2O_coef, CO_coef, CO2_coef] = shomate_coef_wgs;

R = 0.08206;  % gas constant in atm-L/mole-K
Rj = 8.314;   % gas constant in J/mol-K
V = 5;      % reactor volume (not needed in this problem)

T_in = [500:25:1500]';   % vector of Temps to evaluate things at

% Inlet mole flow rates to the reactor (moles/sec)
N_in = [0, 0, 2, 5, 1, 0.1]*1e-3;

CH4_in = N_in(1);
O2_in = N_in(2);
H2_in = N_in(3);
H2O_in = N_in(4);
CO_in = N_in(5);
CO2_in = N_in(6);

% Calculate the thermo at each temperature of interest
for i=1:length(T_in)
    [dH(i),TdS(i),dG(i)] = wgs_thermo(T_in(i));
end

% This section will solve for the equilibrium conditions in the reactor at
% each temperature of interest.  
for i=1:length(T_in)

    Tout_0 = T_in(i);   % guess for Tout
    z1_0 = N_in(5)*0.9;   % guess for extent of reaction

    var_0 = [Tout_0; z1_0];

    options = optimset('Display','off','MaxFunEvals',10000,'MaxIter',1000,'TolX',1e-8,'TolFun',1e-8);
    
    % use fsolve to solve the problem
    var = fsolve(@wgs_solver,var_0,options,T_in(i),N_in);

    Tout(i,1) = var(1);
    z1(i,1) = var(2);
    conv_eq(i,1) = 100*(1 - (CO_in - z1(i))/CO_in);  % calculate conversion from the extent
    
end

CH4 = CH4_in;
O2 = O2_in;
H2 = H2_in + z1;
H2O = H2O_in - z1;
CO = CO_in - z1;
CO2 = CO2_in + z1;

% This part solves for the outlet temperature for various combinations of
% conversion and inlet temperature
options2 = optimset('Display','off','MaxFunEvals',10000,'MaxIter',1000,'TolX',1e-8,'TolFun',1e-8);
conv2 = linspace(0,100,21);
for i=1:length(conv2)
    for j=1:length(T_in)
        T_mat(i,j) = T_in(j);  %generate a matrix of temperatures used
        conv_mat(i,j) = conv2(i);  %generate a matrix of conversions used
        z(i) = CO_in*conv2(i)/100;  % convert the conversion to extent
        
        % solve for the outlet temperatures
        Tout_z(i,j) = fsolve(@wgs_solver_conv,T_in(j)*0.75,options2,T_in(j),N_in,z(i));
        
        % Since we are asked to plot only the feasible region, we need to
        % compare the conversion at each point here to the equilibrium
        % conversion calculated above for each inlet temperature.  If the
        % point is infeasible, then the outlet temp value is replaced with
        % NaN, which will not show up in a plot.
        if(conv_mat(i,j) > conv_eq(j))
            Tout_z_constrained(i,j) = NaN;
        else
            Tout_z_constrained(i,j) = Tout_z(i,j);
        end
    end
end

% pull out the 100% conversion temperatures, as this was asked for in the
% problem as well (the last row in Tout_z)
Tout_100 = Tout_z(end,:)';

% generate the figures required by the problem
figure;
plot(T_in,dH,'-',T_in,TdS,'--',T_in,dG,'-.');
title('Thermochemistry for the Water-Gas Shift Reaction');
xlabel('Temperature [K]'); ylabel('Thermochemistry [kJ/mole]');
legend('dH(Rxn)','T*dS(Rxn)','dG(Rxn)'); set(gca,'xtick',[500:100:1500]);

figure;
set(get(0,'CurrentFigure'),'position',[275  594   1344  504]);
subplot(1,2,1);
plot(T_in,Tout_100 - T_in);
title('Complete Conversion Temperatures');
xlabel('Inlet Temperature [K]'); ylabel('T_O_u_t - T_I_n  [K]');
axis([500 1500 0 150]); set(gca,'xtick',[500:100:1500]);
 
subplot(1,2,2);
plot(T_in,Tout-T_in);
title('Equilibrium Conversion Temperatures');
xlabel('Inlet Temperature [K]'); ylabel('T_O_u_t - T_I_n  [K]');
axis([500 1500 0 150]); set(gca,'xtick',[500:100:1500]);

 
figure;
set(get(0,'CurrentFigure'),'position',[275  594   1344  504]);
subplot(1,2,1);
plot(T_in,Tout_100);
title('Complete Conversion Temperatures');
xlabel('Inlet Temperature [K]'); ylabel('T_O_u_t  [K]');
set(gca,'xtick',[500:100:1500]);
 
subplot(1,2,2);
plot(T_in,Tout);
title('Equilibrium Conversion Temperatures');
xlabel('Inlet Temperature [K]'); ylabel('T_O_u_t  [K]');
set(gca,'xtick',[500:100:1500]);


figure;
plot(T_in,conv_eq);
title('Equilibrium Conversion');
xlabel('Inlet Temperature [K]'); ylabel('CO Conversion  [%]');
set(gca,'xtick',[500:100:1500]);

figure;
surf(conv_mat,T_mat,Tout_z_constrained,'facecolor','interp'); %'EdgeColor','none',
colormap 'jet'; colorbar; axis([0 1 0 1 500 1600]); axis 'auto xy';
title('Physically Realizable Reactor Conditions');
ylabel('T_I_n [K]'); xlabel('CO Conversion  [%]'); zlabel('T_O_u_t [K]');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Other functions used in this problem:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [dH,TdS,dG] = wgs_thermo(T_in)
% this function return the thermochemistry for the species as at the
% requested temperature
% input: T_in = temperature at which thermo will be calculated
% output: dH: enthaply of reaction in kJ/mole
%       dG: Gibb energy of reaction in kJ/mole
%       TdS: Temp times the entropy of reaction in kJ/mole

global CH4_coef O2_coef H2_coef H2O_coef CO_coef CO2_coef R Rj V

[Cp_CH4, H_CH4, S_CH4] = Shomate(T_in,CH4_coef);
[Cp_O2, H_O2, S_O2] = Shomate(T_in,O2_coef);
[Cp_H2, H_H2, S_H2] = Shomate(T_in,H2_coef);
[Cp_H2O, H_H2O, S_H2O] = Shomate(T_in,H2O_coef);
[Cp_CO, H_CO, S_CO] = Shomate(T_in,CO_coef);
[Cp_CO2, H_CO2, S_CO2] = Shomate(T_in,CO2_coef);

G_CH4 = H_CH4 - T_in*S_CH4/1000;
G_O2 = H_O2 - T_in*S_O2/1000;
G_H2 = H_H2 - T_in*S_H2/1000;
G_H2O = H_H2O - T_in*S_H2O/1000;
G_CO = H_CO - T_in*S_CO/1000;
G_CO2 = H_CO2 - T_in*S_CO2/1000;

dH = H_CO2 + H_H2 - (H_CO + H_H2O);   %kJ/mol

TdS = T_in*(S_CO2 + S_H2 - (S_CO + S_H2O))/1000;   %kJ/mol

dG = G_CO2 + G_H2 - (G_CO + G_H2O);   %kJ/mol

return



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function resid = wgs_solver(var,T_in,N_in)
% this is used to find the equilibrium conditions coming out of the reactor
% for a given inlet temp and composition
% inputs:
%   var: [Temp out (K), extent of reaction (moles)]
%   T_in: inlet temperature to reactor (K)
%   N_in: inlet mole flow rates (moles/sec)
% outputs:
%   resid: residuals of the equations we are trying to solve

global CH4_coef O2_coef H2_coef H2O_coef CO_coef CO2_coef R Rj V

CH4_in = N_in(1);
O2_in = N_in(2);
H2_in = N_in(3);
H2O_in = N_in(4);
CO_in = N_in(5);
CO2_in = N_in(6);


Tout = var(1);
z1 = var(2);

% get the thermo parameters for inlet and outlet temps
[Cp_CH4_in,H_CH4_in,S_CH4_in] = Shomate(T_in,CH4_coef);
[Cp_O2_in,H_O2_in,S_O2_in] = Shomate(T_in,O2_coef);
[Cp_H2_in,H_H2_in,S_H2_in] = Shomate(T_in,H2_coef);
[Cp_H2O_in,H_H2O_in,S_H2O_in] = Shomate(T_in,H2O_coef);
[Cp_CO_in,H_CO_in,S_CO_in] = Shomate(T_in,CO_coef);
[Cp_CO2_in,H_CO2_in,S_CO2_in] = Shomate(T_in,CO2_coef);

[Cp_CH4,H_CH4,S_CH4] = Shomate(Tout,CH4_coef);
[Cp_O2,H_O2,S_O2] = Shomate(Tout,O2_coef);
[Cp_H2,H_H2,S_H2] = Shomate(Tout,H2_coef);
[Cp_H2O,H_H2O,S_H2O] = Shomate(Tout,H2O_coef);
[Cp_CO,H_CO,S_CO] = Shomate(Tout,CO_coef);
[Cp_CO2,H_CO2,S_CO2] = Shomate(Tout,CO2_coef);

% calculate the Gibbs for each species in J/mole
G_CH4 = 1000*H_CH4 - Tout*S_CH4;
G_O2 = 1000*H_O2 - Tout*S_O2;
G_H2 = 1000*H_H2 - Tout*S_H2;
G_H2O = 1000*H_H2O - Tout*S_H2O;
G_CO = 1000*H_CO - Tout*S_CO;
G_CO2 = 1000*H_CO2 - Tout*S_CO2;

% Define the molar flow rate out in terms of extents of reaction:
CH4 = CH4_in;
O2 = O2_in;
H2 = H2_in + z1;
H2O = H2O_in - z1;
CO = CO_in - z1;
CO2 = CO2_in + z1;


% Enthalpy balance
resid(1,1) = CH4_in*H_CH4_in + O2_in*H_O2_in + H2_in*H_H2_in +...
    H2O_in*H_H2O_in + CO_in*H_CO_in + CO2_in*H_CO2_in -...
    (CH4*H_CH4 + O2*H_O2 + H2*H_H2 + H2O*H_H2O + CO*H_CO + CO2*H_CO2);

% equilibrium for Reaction
dG = G_CO2 + G_H2 - (G_CO + G_H2O);
dn = 0;
resid(2,1) = (1/R/Tout)^dn*exp(-dG/Rj/Tout) - CO2*H2/(CO*H2O)*(1/V)^dn;

return


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function resid = wgs_solver_conv(Tout,T_in,N_in,z1)
% this is used to find the temperature coming out of the reactor
% for a given conversion, inlet temp, and inlet composition
% inputs:
%   Tout: Temp out (K)
%   T_in: inlet temperature to reactor (K)
%   N_in: inlet mole flow rates (moles/sec)
%   z1: given extent of reaction (moles)
% outputs:
%   resid: residuals of the equations we are trying to solve

global CH4_coef O2_coef H2_coef H2O_coef CO_coef CO2_coef R Rj V

CH4_in = N_in(1);
O2_in = N_in(2);
H2_in = N_in(3);
H2O_in = N_in(4);
CO_in = N_in(5);
CO2_in = N_in(6);

[Cp_CH4_in_in,H_CH4_in,S_CH4_in] = Shomate(T_in,CH4_coef);
[Cp_O2_in,H_O2_in,S_O2_in] = Shomate(T_in,O2_coef);
[Cp_H2_in,H_H2_in,S_H2_in] = Shomate(T_in,H2_coef);
[Cp_H2O_in,H_H2O_in,S_H2O_in] = Shomate(T_in,H2O_coef);
[Cp_CO_in,H_CO_in,S_CO_in] = Shomate(T_in,CO_coef);
[Cp_CO2_in,H_CO2_in,S_CO2_in] = Shomate(T_in,CO2_coef);

[Cp_CH4,H_CH4,S_CH4] = Shomate(Tout,CH4_coef);
[Cp_O2,H_O2,S_O2] = Shomate(Tout,O2_coef);
[Cp_H2,H_H2,S_H2] = Shomate(Tout,H2_coef);
[Cp_H2O,H_H2O,S_H2O] = Shomate(Tout,H2O_coef);
[Cp_CO,H_CO,S_CO] = Shomate(Tout,CO_coef);
[Cp_CO2,H_CO2,S_CO2] = Shomate(Tout,CO2_coef);

CH4 = CH4_in;
O2 = O2_in;
H2 = H2_in + z1;
H2O = H2O_in - z1;
CO = CO_in - z1;
CO2 = CO2_in + z1;

% Enthalpy balance
resid = CH4_in*H_CH4_in + O2_in*H_O2_in + H2_in*H_H2_in +...
    H2O_in*H_H2O_in + CO_in*H_CO_in + CO2_in*H_CO2_in -...
    (CH4*H_CH4 + O2*H_O2 + H2*H_H2 + H2O*H_H2O + CO*H_CO + CO2*H_CO2);

return


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [CH4_coef, O2_coef, H2_coef, H2O_coef, CO_coef, CO2_coef] = shomate_coef_wgs()
% this just stores the shomate coefficients so I don't have to looks at
% them, and returns the coef matrices that can be used in Shomate.m

CH4_coef = [...
    -0.703029	85.81217
        108.4773	11.26467
        -42.52157	-2.114146
        5.862788	0.138190
        0.678565	-26.42221
        -76.84376	-153.5327
        158.7163	224.4143
        300         1300
        1300        6000];

O2_coef = [...
        29.65900
        6.137261
        -1.186521
        0.095780
        -0.219663
        -9.861391
        237.9480
        298
        6000];
    
H2_coef = [...
        33.066178	18.563083	43.413560
        -11.363417	12.257357	-4.293079
        11.432816	-2.859786	1.272428
        -2.772874	0.268238	-0.096876
        -0.158558	1.977990	-20.533862
        -9.980797	-1.147438	-38.515158
        172.707974	156.288133	162.081354
        298         1000        2500
        1000        2500        6000];


H2O_coef = [...
        30.09200	41.96426
        6.832514	8.622053
        6.793435	-1.499780
        -2.534480	0.098119
        0.082139	-11.15764
        -250.8810	-272.1797
        223.3967	219.7809
        300         1700
        1700        6000];


CO_coef = [...
        25.56759	35.15070
        6.096130	1.300095
        4.054656	-0.205921
        -2.671301	0.013550
        0.131021	-3.282780
        -118.0089	-127.8375
        227.3665	231.7120
        298         1300
        1300        6000];


CO2_coef = [...
        24.99735	58.16639
        55.18696	2.720074
        -33.69137	-0.492289
        7.948387	0.038844
        -0.136638	-6.447293
        -403.6075	-425.9186
        228.2431	263.6125
        298         1200
        1200        6000];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Cp,H,S]=Shomate(T,molecule_data)
% Program to compute thermo stored as Shomate coefficients
% W.H. Green, 9/27/02
% Outputs:
%     1) constant-pressure heat capacity Cp in J/mol K
%     2) enthalpy in kJ/mol 
%     3) entropy in J/mol K
%   Note, if T is a vector, these will all be vectors of the same shape.
% Inputs: T in K, molecule_data = [A B C D E F G Tmin Tmax]'
%     A-G, Tmin, Tmax from NIST Webbook http://webbook.nist.gov
%     in Joule/mole Kelvin units
% Cp0= A + B*t + C*t^2 + D*t^3 + E/t^2
% H0= A*t + B*t^2/2 + C*t^3/3 + D*t^4/4 - E/t + F
% S0= A*ln(t) + B*t + C*t^2/2 + D*t^3/3 - E/(2*t^2) + G
% Tmin and Tmax define the range over which 
%   these A-G are accurate
% Sometimes there are different parameter sets for different T ranges
%   if so, make molecule_data a matrix, with a column for each T range.
%  First: figure out how many parameter sets we have
%          and how many T's the user has input
dim_molecule_data=size(molecule_data);
number_of_parameter_sets=dim_molecule_data(2);
dim_T=size(T);
number_of_T=dim_T(1);
Cp=-1e20*ones(dim_T);   % if you see any -1e20's in output, something went wrong
H=Cp;                   % most likely your T was outside the T range where the
S=Cp;                   % Shomate fit is valid.
for i=1:number_of_parameter_sets
    Tmin=molecule_data(8,i); Tmax=molecule_data(9,i);
    for j=1:number_of_T
     if((T(j)>=Tmin)&(T(j)<=Tmax))
        A = molecule_data(1,i); B=molecule_data(2,i);
        C = molecule_data(3,i); D=molecule_data(4,i);
        E = molecule_data(5,i); F=molecule_data(6,i);
        G = molecule_data(7,i);
        t=0.001*T(j);  % NIST t= T/1000 Kelvin
        Cp(j,1)=A+(B*t)+(C*t*t)+(D*(t^3))+(E/(t*t)); 
        H(j,1)=(A*t)+(0.5*B*t*t)+(C*(t^3)/3)+(0.25*D*(t^4))-(E/t)+F;
        S(j,1)=(A*log(t))+(B*t)+(0.5*C*t*t)+(D*(t^3)/3)-(0.5*E/(t*t))+G;
     end
    end
end
% if any of the values are -1e20, it means that the Shomate polynomial
%  was not valid in the requested T range.
% 
% Sample input
% For H2
% H2_data=[33.10780 -11.50800 11.60930 -2.844400 -0.159665 -9.991971 172.7880 298 1500]';
% By running [Cp,H,S]=Shomate(300, H2_data);
%
% Sample output
% » Cp
% Cp =
%    28.8494
% » H
% H =
%    0.0534
% » S
% S =
%  130.8586

