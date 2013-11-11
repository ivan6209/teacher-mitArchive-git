% 10.34 - Fall 2006 HW#1
% Problem #2
% Equation Solvers
% Rob Ashcraft - Sept. 7th, 2006

% accompanying files (included in this function): fmin_eqn.m and fzero_eqn.m

function Problem2
% This function serves to set up the problem and constants used in solving
% the RK equation of state; generates a plot of the final solution vs. initial guess

% clear the workspace and command window
clear; clc;

% define certain global variables that are available to other functions
% without explicitly passing them (a global statement must also occur in
% the function where these are needed)
global psi omega sigma eps Tc Pc P R w;

% define the variable EOS parameters and physical constants
psi = 0.42748;
omega = 0.08664;
sigma = 1;
eps = 0;
Tc = 647.1;     % K
Pc = 217.7;     % atm
P = 1;          % atm
R = 0.08206;    % atm-L/mole-K
w = 0.152;      % acentric factor
T = 300;        % temp in K

b = omega*R*Tc/Pc;    % b parameter in the EOS (used in the plot)

V_0_vec = linspace(1,50,50);  %vector of initial guesses in L/mole

% solver options.  These can be very important with complex problems.  This
% particular option turns off the output display, so it does not have to
% print it to the command window (particularly annoying with iterating over fsolve)
options = optimset('Display','off'); 

% solve the equation using the three solvers specified
for i=1:length(V_0_vec)
    V_fzero_300K_gas(i) = fzero(@fzero_eqn,V_0_vec(i),options,T);

    V_fsolve_300K_gas(i) = fsolve(@fzero_eqn,V_0_vec(i),options,T);

    V_fminsearch_300K_gas(i) = fminsearch(@fmin_eqn,V_0_vec(i),options,T);
end

disp(['Vapor Volume Root (fzero, V_guess=50) (L/mole):  ',num2str(V_fzero_300K_gas(length(V_0_vec)))]);
disp(['Vapor Volume Root (fsolve, V_guess=50) (L/mole):  ',num2str(V_fsolve_300K_gas(length(V_0_vec)))]);
disp(['Vapor Volume Root (fminsearch, V_guess=50) (L/mole):  ',num2str(V_fminsearch_300K_gas(length(V_0_vec)))]);

% plot the solver solution as a function of initial guess
figure;
plot(V_0_vec,V_fzero_300K_gas,'.',V_0_vec,V_fsolve_300K_gas,'x',V_0_vec,V_fminsearch_300K_gas,'o',[0,50],[b,b],'--')
xlabel('Volume Initial Guess [L/mole]'); ylabel('Resulting Volume [L/mole]'); 
legend('fzero Result','fsolve Result','fminsearch Result','EOS b-value (lower physical limit)');



%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%% Include other functions in this file.
% This function defines the equation that should be equal to zero as a
% function of Volume and Temperature;  this is called when using the
% "fzero" or "fsolve" solver function

function resid = fzero_eqn(V,T)
%inputs:
%   V = specific volume in L/mole
%   T = temperature of the system in Kelvin
%outputs:
%   resid = residual of the EOS equation, which should -> 0 when solved
%           correctly

% this defines the global variables available to this function
global psi omega sigma eps Tc Pc P R w;

Tr = T/Tc;   %reduced temperature

% Define the EOS parameters
alpha = Tr^(-1/2);

a = psi*alpha*(R*Tc)^2/Pc;

b = omega*R*Tc/Pc;

% Equation to solve (set to zero).  Notice the P had to be moved to the RHS
% so that the equation would equal zero.  This is a recurring theme with
% many solvers
resid = -P + R*T/(V-b) - a/((V+eps*b)*(V+sigma*b));

return;



%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%
% This function is used by fminsearch to find the optimum value of the
% variable that minimizes an objective function, Esqr in this case.  

function Esqr = fmin_eqn(V,T)
%inputs:
%   V = specific volume in L/mole
%   T = temperature of the system in Kelvin
%outputs:
%   Esqr = the square of the residual of the EOS equation, which should be 
%          minimized to 0 when solved correctly

global psi omega sigma eps Tc Pc P R w;

Tr = T/Tc;

alpha = Tr^(-1/2);

a = psi*alpha*(R*Tc)^2/Pc;

b = omega*R*Tc/Pc;

resid = -P + R*T/(V-b) - a/((V+eps*b)*(V+sigma*b));

% in this case, the plain residual cannot be used since a minimization is
% being performed, and not trying to set something to zero.  The easy way
% to solve this is to simply square the residual to make it always
% positive.  If you had multiple equations, you could use the sum of
% squares of errors as the residual in a similar manner.

Esqr = resid^2;

return;
