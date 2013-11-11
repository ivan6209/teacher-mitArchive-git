function problem_2_1(eps1)
%compare exact roots of x^5-2x^2+eps1=0 with those found by asymptotic
%expansion technique

if nargin<1, eps1 = 0.1; end 

display(['roots of x^5 - 2x^2 + ',num2str(eps1),':']);
%exact roots 
x_exact = roots([1 0 0 -2 0 eps1]);

%asymptotic formula 
x_asymptotic = [ 1.26 - 0.132*eps1,  ...
            -0.63 - 1.09*i + (0.066 - 0.115*i)*eps1,...
            -0.63 + 1.09*i + (0.066 + 0.115*i)*eps1,...
             sqrt(eps1/2) + eps1^2/16,...
            -sqrt(eps1/2) + eps1^2/16]';
        
display(x_exact);
display(x_asymptotic);