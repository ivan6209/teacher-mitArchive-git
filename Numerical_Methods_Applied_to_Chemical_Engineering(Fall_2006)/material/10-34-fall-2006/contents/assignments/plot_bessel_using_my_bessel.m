% problem 1, HW set 1
% use my_bessel to plot the bessel function
% Sandeep Sharma 09/13/2006
% input: takes the x upto which the plot is to be made.

function plot_bessel_using_my_bessel(x_end)

%divides the space between 0 and x_end into 40 parts.
x = linspace(0,x_end,40);

%calculates bessel function for each x(i) and stores it in
% the vector j_my_bessel
for i=1:length(x)
    [j_my_bessel(i), n(i)] = my_bessel(0,x(i));
end

plot(x,j_my_bessel);
title('Bessel function of first kind using mybessel');
xlabel('x');
ylabel('y(x)');

%start a new plot.
figure;

%plot the number of terms used.
plot(x,n,'*');
title('Number of terms included while using mybessel');
xlabel('x');
ylabel('number of terms');

return

%//*******************************************************************

% problem 1, HW set 1
% estimation of bessel fuction using the infinte series sum
% input : nu is the order of the bessel function
%       : x is the value at which the bessel function is to be evaluated.

function [value,n] = my_bessel(nu,x)

%n is the number of terms calculated so far
%value of the sum of the series upto the 1st terms
%tn is the value of 2nd term
n=1;
value =1;
tn = (-1)*(x/2)^(nu+2)/(factorial(1)*gamma(nu+1+1));

%this wile loop ensures that it adds the value of tn to the value only
% if tn is greater than 0.001*value.
while(abs(tn)>=abs(0.001*value))
    value = value+tn;
    n=n+1;
    tn = (-1)^(n)*(x/2)^(nu+2*n)/(factorial(n)*gamma(nu+n+1));
end
return

%//********************************************************************