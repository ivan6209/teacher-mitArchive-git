%% MIT 18.311, S 2009, Aslan Kasimov.
% Press Cmd (or Ctrl)-Enter to run a cell
%% Solution of 1D heat equation for a rod
% u_t = k*u_xx on 0<x<2 with u(x,0) = 0, u(0,t) = 1, and u(2,t) = 0
clear all; clf
tend = 3;  %solution is found from t=0 to t=tend
nmax = 100; %number of terms in the Fourier sum
x = linspace(0,2,200); t = linspace(0,tend,200);
[xx tt] = meshgrid(x,t);

un = @(n,x,t) exp(-n^2*pi^2/4*t)/n.*sin(n*pi/2*x);

usum(1:length(x),1:length(t)) = 0;
for n=1:nmax, usum = usum + un(n,xx,tt); end

u = ones(size(t))'*(1-x/2) - 2/pi*usum;

surf(xx,tt,u,'LineStyle','none'); xlabel 'x', ylabel 't', zlabel 'u'

%% Solution of the 1d wave equation for a plucked string: u_tt=u_xx,
% u(x,0) = u0(x), u_t(x,0)=0, u(0,t)=u(2,t)=0.
clear all; clf

%Analytical solution of the wave equation
un = @(n,x0,x,t) 8/pi^2/n^2*sin(n*pi*x0/2)*cos(n*pi*t/2)*sin(n*pi*x/2);

nmax = 50; x0 = 1.1; xmax = 2;
tend = 10; dt = 0.1; trange = 0:dt:tend;
ymax  = 1.2*(xmax - x0)*x0;
x = linspace(0,xmax,200);

set(gca,'nextplot','replacechildren')
xlabel 't', ylabel 'u'
axis([0 xmax -ymax ymax]);

for t=trange,
    uan = zeros(size(x));
    for nn=1:nmax, uan = uan + un(nn,x0,x,t); end
    plot(x,uan,'-','LineWidth',2),  grid on;
    getframe;
end

%% 4-4:2: 
% To run the cell, press Cmd-Enter
clear all; clf

L = 30; x = linspace(-2,L,500);  %the x-axis data
set(gca,'nextplot','replacechildren')
xlabel 'x', ylabel 'u'

%the initial data
f = @(x) (1 - x.^2).^2.*(abs(x)<1);

for t = 0:1:6
    u1 = 1/4*f(x - t) + 3/4*f(x - 5*t);
    plot(x,t + u1,'-','LineWidth',2),  grid on; hold on
    axis([-2 L -Inf Inf]);
    title(['Solution of 4-4:2 at t = 0:1:6']);
    getframe;
end

