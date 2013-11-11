% problem 1, HW set 1
% use besselj to plot the bessel function
% 09/13/2006
% input: takes the x upto which the plot is to be made.

function plot_bessel_using_besselj(x_end)

%divides the space between 0 and x_end into 40 parts.
x = linspace(0,x_end,40);

%calculates bessel function for each x(i) and stores it in
% the vector j_my_bessel
for i=1:length(x)
    j_besselj(i) = besselj(0,x(i));
end

plot(x,j_besselj);
title('Bessel function of first kind using besselj');
xlabel('x');
ylabel('y(x)');



return