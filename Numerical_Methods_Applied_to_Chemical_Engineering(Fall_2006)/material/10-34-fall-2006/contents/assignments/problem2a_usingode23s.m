function [x,y] = problem2a_usingode23s(a,c)
%function uses fzero to calculate the gradient of T at x=0
% and the cost function is the square of difference of Tcalculated at X = L
% and Tambient.

%input:
%       a: the constant coefficient in the problem
%       c: the coefficient of T^2 in the expression of dI/dt

%output:
%       x: The distance along the filter width
%       y: a nX3 matrix, with the first column ad T, the second column as
%       T_grad and the third column as Intensity.



params.L = 0.01; %width of the channel
params.k_therm = 0.6; % thermal conductivity J/s/m/K
params.Ta = 300; % Ambient Temperature K
params.I0 = 30e4; %J/m3/s
params.a = a;
params.c = c;

%Guess an initial guess for the T_gradient

T_grad_0 = -100000;

T_grad = fzero(@solveTgrad, T_grad_0,[],params);

%once the we have solved for T_grad we will just go ahead and solve the ode
%to get the appropriate profiles of temperature and intensity

%cputime when the code was started
start = cputime();

y0 = [params.Ta, T_grad, params.I0];
[x,y] = ode23s(@odefun, [0 params.L], y0, [], params);

%calculate the cputime taken by the ode solver.
totaltime = (cputime-start);
output = strcat('The time taken by ode23s = ',num2str(totaltime),' s\n');
fprintf(output);

%calculate the maximum temperature and where it occurs.
[T,I] = max(y(:,1));
output = strcat('The maximum temperature achieved is \t  ',num2str(T),...
    ' K, at \t ', num2str((x(I)*100)), ' cm \n');
fprintf(output);
output = strcat('The number of integration steps used before maximum T is \t',num2str(I),' out of total \t',num2str(length(x)),'\n');
fprintf(output);

figure
plot(x*100,y(:,1));
title('The Temperature in the filter calculated using ode23s');
xlabel('Distance (cm)');
ylabel('Temperature (K)');

% figure;
% plot(x*100,y(:,3));
% title('The Intensity of light in the filter');
% xlabel('Distance (cm)');
% ylabel('Intensity (W/m^2)');


return;


%//***********************************************************************


function f = solveTgrad(T_grad, params)
%given a T_grad, calculates T at x=L and gives the square of difference
%between this T and Tambient.

%inititalize f
f = 0;

%the dependent variables for which ode is formed are T, T_grad and I.
%the initial conditions are
y0 = [params.Ta, T_grad, params.I0];

[x, y] = ode23s(@odefun, [0 params.L], y0, [], params);

f = (params.Ta - y(length(x),1));
return;

%**************************************************************************


function f = odefun(x,y,params)
%gives the right hand sides of the differential equations

f = zeros(3,1);

%unpack the parameters
a = params.a;
c = params.c;
k = params.k_therm;


f(1) = y(2);
f(2) = -(a + c*y(1)^2)*y(3)/k;
f(3) = -(a + c*y(1)^2)*y(3);

return;