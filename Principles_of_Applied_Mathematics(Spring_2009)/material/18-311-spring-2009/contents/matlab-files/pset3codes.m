%% MIT 18.311, S 2009, Aslan Kasimov.
% Press Cmd (or Ctrl)-Enter to run a cell
%% Problem 3.1a. Solution of 1D heat equation for a rod
% u_t = u_xx on -pi<x<pi with u(x,0) = max(1-abs(x),0) and
% and u(+/-pi,t) = 0
clear all; clf
tend = 10;  %solution is found from t=0 to t=tend
nmax = 100; %number of terms in the Fourier sum
x = linspace(-pi,pi,200); t = linspace(0,tend,200);
[xx tt] = meshgrid(x,t);

un = @(n,x,t) exp(-(n-0.5)^2*t)*sin(n-0.5)/(n-0.5).*cos((n-0.5)*x);

u(1:length(x),1:length(t)) = 0;
for n=1:nmax, u = u + un(n,xx,tt); end

u = 2/pi*u;

surf(xx,tt,u,'LineStyle','none'); xlabel 'x', ylabel 't', zlabel 'u'
title(['Solution of 3.1a']);

%% 3.1b. Solution of the 1d wave equation for a plucked string: u_tt=u_xx,
% u(x,0) = u0(x), u_t(x,0)=0, u(-pi,t)=u(pi,t)=0.
clear all; clf

%Analytical solution of the wave equation
% 1D plots
un = @(n,x,t) (1-cos(n-0.5))/(n-0.5)^2.*cos((n-0.5)*t).*cos((n-0.5)*x);

nmax = 200; L = pi; N = 200;
tend = 20; dt = 0.1; trange = 0:dt:tend;
x = linspace(-L,L,N);

set(gca,'nextplot','replacechildren')
xlabel 'x', ylabel 'u'
axis([-L L -1.2 1.2]);
title(['Solution of 3.1b']);

for t=trange,
    u = zeros(size(x));
    for nn=1:nmax, u = u + 2/pi*un(nn,x,t); end
    plot(x,u,'-','LineWidth',2),  grid on;
    getframe;
end

% 3D plot of u=u(x,t)
t = linspace(0,tend,N);
[xx tt] = meshgrid(x,t);

u(1:length(x),1:length(t)) = 0;
for n=1:nmax, u = u + un(n,xx,tt); end

u = 2/pi*u;
surf(xx,tt,u,'LineStyle','none'); xlabel 'x', ylabel 't', zlabel 'u'
axis([-L L 0 tend]);
title(['Solution of 3.1b']);

%% 3.3: 
% To run the cell, press Cmd-Enter
clear all; clf

L = 10; x = linspace(-L,L,500);  %the x-axis data
set(gca,'nextplot','replacechildren')
xlabel 'x', ylabel 'u'

%the initial data
f = @(x) max(1-abs(x),0);

for t = 0:1:6
    u = 0.5*(f(x - t) + f(x + t));
    plot(x,t + u,'-','LineWidth',2),  grid on; hold on
    getframe;
end
axis([-L L -Inf Inf]);
title(['Solution of 3.3 at t = 0:1:6']);

