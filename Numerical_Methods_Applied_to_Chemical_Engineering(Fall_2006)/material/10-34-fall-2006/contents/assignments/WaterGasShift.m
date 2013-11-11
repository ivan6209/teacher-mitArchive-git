% 10.34 - Fall 2006
% HW Set#2, Problem #4a
% Rob Ashcraft - Sept. 11, 2006

% This function solves for the reactor temperature and outlet stream
% composition for a single reaction CSTR for the water-gas shift reaction.
% The equations are written in terms of a single progress variable and the
% reactor temperature.



function [x_out, Treactor] = WaterGasShift(P,Tin,x_in)
% inputs:
%    P =  reactor pressure
%    Tin =  inlet reactor temperature (K)
%    x_in = [CO H2O CO2 H2] (mole fractions)
% outputs:
%    x_out = outlet mole fractions
%    Treactor = reactor temperature

% define global variables for the constants in the problem
global Vreactor res_time R Rj A Ea dHrxn dSrxn Cp_vec h

x_CO_in = x_in(1);
x_H2O_in = x_in(2);
x_CO2_in = x_in(3);
x_H2_in = x_in(4);

PCOin = P*x_CO_in;
PH2Oin = P*x_H2O_in;
PCO2in = P*x_CO2_in;
PH2in = P*x_H2_in;

% Choose the initial guesses for Treactor and the progress variable (z).  z
% is the number of moles of consumed in the reactor (extent of reaction).
% The initial reactor temperature is guessed to be 105% of the inlet.  The
% progress variable is guessed as 10% of the inlet CO composition.
Treactor_0 = Tin*1.05;
z_0 = P*Vreactor/R/Tin*x_in(1)*0.1;

var_0 = [z_0; Treactor_0];

% Options for the solver... probably not needed for this case.
options = optimset('MaxFunEvals',20000,'MaxIter',10000,'Display','final');

% call fsolve to solve the problem
var = fsolve(@WGS_solver,var_0,options,P,Tin,x_in);

z = var(1);
Treactor = var(2);

% determine the outlet mole fractions from the progress variable
xCO = (PCOin - z*R*Treactor/Vreactor)/P;
xH2O = (PH2Oin - z*R*Treactor/Vreactor)/P;
xCO2 = (PCO2in + z*R*Treactor/Vreactor)/P;
xH2 = (PH2in + z*R*Treactor/Vreactor)/P;

x_out = [xCO; xH2O; xCO2; xH2];



%%%%%%%%%%%%%%%%%%%%%%%%%
% This is the function that evaluates the residuals of the equations for
% the system
function resid = WGS_solver(var,P,Tin,x_in)
% inputs:
%   var = [z, Treactor] = system variables to be solved
%   P, Tin, x_in =  described above
% outputs:
%   resid = [resid1, resid2] residuals for the two equations

% define global variables for the constants in the problem
global Vreactor res_time R Rj A Ea dHrxn dSrxn Cp_vec h

z = var(1);
Treactor = var(2);

Cp_in = Cp_vec*x_in;

dGrxn = dHrxn - Treactor*dSrxn;

x_CO_in = x_in(1);
x_H2O_in = x_in(2);
x_CO2_in = x_in(3);
x_H2_in = x_in(4);

PCOin = P*x_CO_in;
PH2Oin = P*x_H2O_in;
PCO2in = P*x_CO2_in;
PH2in = P*x_H2_in;

% convert partial Pressures to progress variable
PCO = PCOin - z*R*Treactor/Vreactor;
PH2O = PH2Oin - z*R*Treactor/Vreactor;
PCO2 = PCO2in + z*R*Treactor/Vreactor;
PH2 = PH2in + z*R*Treactor/Vreactor;

% Write out the rate equation for the system
rate = A*exp(-Ea/Rj/Treactor)*(PCO*PH2O - PH2*PCO2*exp(dGrxn/Rj/Treactor))/(1 + (PCO/0.2));

% calculate the residuals for the conversion equation and energy balance
resid_1(1,1) = z - rate*res_time;

resid_1(2,1) = -dHrxn*rate - (P*Vreactor/R/Treactor)/res_time*(Cp_in*(Treactor-Tin)) - h*(Treactor-300);

resid = (resid_1);
