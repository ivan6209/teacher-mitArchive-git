% 10.34 - Fall 2006
% HW Set#2, Problem #2a
% Rob Ashcraft - Sept. 11, 2006

% This function can do two things: (1) SOlve for the polynomial
% coefficients of an Nth-order polynomial given N+1 data points, (2) Find
% the best fit coefficients for an Nth-order polynomial given more than N+1
% data points.  
% f(x) = a0 + a1*x + a2*x^2 + ... + aN*x^N
%If you want to always use the largest polynomial possible for the data,
%N_order does no have to be passed to the function

function a_vec = calc_poly_coeff(x,f,N_order)
% Input: 
%   x = data for the independent variable 
%   f = data for dependent variable
%   N_order = order of the polynomial you want to fit
%       
% Output
%   a_vec = polynomial coefficients = [a0; a1; ... aN]
%       

% First, check to see if the number of arguments passed to the function is
% equal to 2 (i.e. the user only specified the x and f data).  If this is
% true, the user wants to largest polynomial possible and the coefficients
% can be found by solving a linear system: A*x = f. "nargin" in a built-in
% matlab command that tell you have many inputs were passed to a function

if(nargin == 2)
    
    % Generate the system matrix, with rows of the form: [1 x x^2 ... x^N]
    for i=1:length(x)
        for j=1:length(x)
            X_mat(j,i) = x(j)^(i-1);
        end
    end
    
    % determine and display the condition number of the system matrix
    disp(['The condition number for the polynomial is:  ',num2str(cond(X_mat),'%5.3e')]);
    disp('  ');
    
    % use the backslash command solve for the parameters
    a_vec = X_mat\f;

% If the user supplied the desired order, there are three possibilities:
% (1) you have too many parameters for the amount of data, (2) the number
% of parameters and data is equal and you can solve a linear system, or (3)
% the data set is larger than the number of parameters and a linear
% regression must be performed to find the parameter.  
elseif(nargin == 3)
    if(N_order+1 > length(f))
        disp(['You do not have enough data to solve for the coefficients of the order ',num2str(N_order),' polynomial.']);
        return;  % kicks out of the function... probably would cause errors.
        
    elseif(N_order+1 == length(f))
        for i=1:length(x)
            for j=1:length(x)
                X_mat(j,i) = x(j)^(i-1);
            end
        end

        a_vec = X_mat\f;       

    else
        
        for i=1:(N_order+1)
            for j=1:length(x)
                X_mat(j,i) = x(j)^(i-1);
            end
        end

        % in this case, a linear regression is performed to get the parameters
        a_vec = X_mat'*X_mat\X_mat'*f
        
    end
end
    