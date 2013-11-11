% 10.34 - Fall 2006
% HW Set#2, Problem #2a
% Rob Ashcraft - Sept. 11, 2006

% This function returns the Cv of a given molecule at the value of T
% requested in T_vec, given the data that is to be to fit to a polynomial
% of order N_order

function Cv_T_poly = Cv_CO2_poly(T_vec,T_data,Cv_data,N_order)
% Input: 
%   T_vec = temperatures value where the Cv is to be evaluated
%   T_data = data for the independent variable 
%   Cv_data = data for dependent variable
%   N_order = order of the polynomial you want to fit
%       
% Output
%   Cv_T_poly = vector of Cv values for each T in T_vec based on the
%   polynomial model of order N_order
%

% First, check to see if the number of arguments passed to the function is
% equal to 3 (i.e. the user did not specify N_order).  If this is
% true, the user wants to largest polynomial possible.  "nargin" in a built-in
% matlab command that tell you have many inputs were passed to a function.  If 
% N_order is specified, go ahead and pass it to the coefficient solver.
if(nargin == 3)
    a_vec_poly = calc_poly_coeff(T_data,Cv_data);
else
    a_vec_poly = calc_poly_coeff(T_data,Cv_data,N_order);
end
    
% Write out the system matrix for the polynomial for length of T_vec
for i=1:length(T_vec)
    for j=1:length(a_vec_poly)
        T_mat_poly(i,j) = T_vec(i)^(j-1);
    end
end

% Determine the Cv values at each T through simple math: Cv = T_mat*a_vec
Cv_T_poly = T_mat_poly*a_vec_poly;
    
% Print the coefficient values to the command window
disp('Polynomial coefficient values:');
disp(['  a0 = ',num2str(a_vec_poly(1))]);
disp(['  a1 = ',num2str(a_vec_poly(2))]);
disp(['  a2 = ',num2str(a_vec_poly(3))]);
disp(['  a3 = ',num2str(a_vec_poly(4))]);
disp('  ');



