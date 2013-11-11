% 10.34 - Fall 2006
% HW Set#2, Problem #2a
% Rob Ashcraft - Sept. 11, 2006

% This function find the best fit coefficients for the Pade form
%     f(x) = (a0 + a1*x + Cv,inf*a2*x^2)/(1 + a3*x + a2*x^2);
% This must first be linearized in terms of the parameters as:
%     f(x) = a0 + x*a1 + (Cv,inf*x^2 - f(x)*x^2)*a2 - x*a3

function a_vec = calc_Pade_coeff(x,f,Cv_inf)
% Input: 
%   x = data for the independent variable 
%   f = data for dependent variable
%   Cv_inf = value of f(x) at infinite x
%       
% Output
%   a_vec = polynomial coefficients = [a0; a1; a2; a3]
%

% first build the system matrix for this type of equation
for i=1:length(x)
    X_mat(i,1) = 1;
    X_mat(i,2) = x(i);
    X_mat(i,3) = (Cv_inf - f(i))*x(i)^2;
    X_mat(i,4) = -x(i)*f(i);
end

% Check to see if you have enough data to determine the 4 coefficients.  If
% you do, the perform a linear regression to detemine the parameters.  If
% the number of parameters and data points are the same, doing a linear
% regression and solving a linear system of equations is identical.  Since
% the N_param does not change with this form, it is always written as a
% linear regression problem

if(length(x) < 4)
    disp('You do not have enough data to solve for the 4 coefficients in the Pade form.');

else
    % since N_data >= N_coef, you can perform a regression to get a's
    a_vec = X_mat'*X_mat\X_mat'*f;
end

