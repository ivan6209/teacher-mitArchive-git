% 10.34 - Fall 2006
% HW Set#2, Problem #2a
% Rob Ashcraft - Sept. 11, 2006

% This function returns the Cv of a given molecule at the value of T
% requested in T_vec, given the data that is to be to fit to Pade form

function Cv_T_Pade = Cv_CO2_Pade(T_vec,T_data,Cv_data,Cv_inf)
% Input: 
%   T_vec = temperatures value where the Cv is to be evaluated
%   T_data = data for the independent variable 
%   Cv_data = data for dependent variable
%   Cv_inf = value of Cv(T) at infinite T
%       
% Output
%   Cv_T_Pade = vector of Cv values for each T in T_vec based on the
%   Pade model with given Cv_inf
%

% call the function to determine the parameters of the Pade form
a_vec_Pade = calc_Pade_coeff(T_data,Cv_data,Cv_inf);

% Evaluate Cv at each temperature using the element-by-element operations
% designateb by using the "." operand
Cv_T_Pade = (a_vec_Pade(1) + a_vec_Pade(2).*T_vec + Cv_inf*a_vec_Pade(3).*T_vec.^2)./...
            (1 + a_vec_Pade(4).*T_vec + a_vec_Pade(3).*T_vec.^2);

        
% Print the coefficient values to the command window
disp('Pade coefficient values:');
disp(['  a0 = ',num2str(a_vec_Pade(1))]);
disp(['  a1 = ',num2str(a_vec_Pade(2))]);
disp(['  a2 = ',num2str(a_vec_Pade(3))]);
disp(['  a3 = ',num2str(a_vec_Pade(4))]);
disp('  ');

return;
        