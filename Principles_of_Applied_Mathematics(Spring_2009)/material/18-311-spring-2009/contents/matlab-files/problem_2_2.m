function problem_2_2
%compare numerical solution of y''=3y*cos(pi*x/2), y(0)=0, y(1)=1,
%with that found by asymptotic expansion technique for y''=eps*y*cos(pi*x/2),
%y(0)=0, y(1)=1, at eps=3

global eps1

%numerical solution. First rewrite the equation as a system:
% y' = z, z' = 3y*cos(pi*x/2), and then call bvp4c
clc, clf
eps1 = 3;
x = linspace(0,1); 

solinit = bvpinit(x, @yinit); %generate the initial guess

sol_num = bvp4c(@odefun, @bcfun, solinit);
%asymptotic formula
sol_asym = @(x) x - eps1*16/pi^3*( x - sin(pi*x/2) + pi/4*x.*cos(pi*x/2) ); 

plot(sol_num.x, sol_num.y(1,:),'-r',x,sol_asym(x),'--b'); grid on;
xlabel 'x', ylabel 'y'
title ([' Solution of problem 2.2 at \epsilon = ', num2str(eps1)])
legend('numerical','asymptotic','Location','NW');

function yprime = odefun(x,y,eps1)
%evaluate the rhs of the ODE system
global eps1

yprime = [ y(2); eps1*y(1)*cos(pi*x/2) ];

function res = bcfun(ya,yb)
%BC's at x=a and x=b; res must be 0
res = [ya(1); yb(1)-1];

function init_guess = yinit(x)
%provide an initial guess for the solution
init_guess = [x; 1];
