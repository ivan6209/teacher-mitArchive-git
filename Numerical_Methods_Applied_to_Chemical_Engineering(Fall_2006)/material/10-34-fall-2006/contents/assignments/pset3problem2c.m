function u=pset3problem2c(n)
% function to solve the BVP d2T/dt2 + epsilon*I/k = 0 and dI/dt = epsilon*I 
% epsilon = e_0 + e_1*T^2, solves by changing e1 incrermentally.
% written by Sandeep Sharma 09/19/2006

y=linspace(0,0.01,n);

%make incremental changes in the value of e_1
e_1 = [-1e-7; -1e-6; -1e-5; -7e-5; -1e-4; -2e-4; -1e-4]; 

u_in = solve_laser(n,-10.5361,e_1(1));

%for each new calculation use the result of the previous calculation
for i=2:length(e_1)
    u = solve_laser(n,-10.5361,e_1(i),u_in);
    u_in = u;
end

plot(100*y,u(1:n));
title('Intensity of laser as a function of width');
xlabel('width (cm)');
ylabel('Intensity (MW/m^2)');

figure;
plot(100*y,u(n+1:2*n));
title('Temperature as a function of width for non-uniform laser absorption');
xlabel('width (cm)');
ylabel('Temperature (K)');

[T_max,index] = max(u(n+1:2*n));
output = strcat('The maximum temperature is T = ',num2str(T_max),' K\n');
fprintf(output);
output = strcat('The y-value at which temperature is maximum = ',num2str(y(index)*100),' cm\n');
fprintf(output);

return;

%//************************************************************************


function u = solve_laser(n,e0,e1,u_in)
% function to solve the BVP d2T/dt2 + epsilon*I/k = 0 and dI/dt = epsilon*I 
% written by Sandeep Sharma 09/19/2006
% inputs:
%     n : number of grid points
%     e0: the constant term in epsilon
%     e1: the coefficient of the T^2 term
% output:
%     u: the vector of length 2n, where u(1:n) is vector of all I, u(n+1,2n) is a vector of all T

w = 0.01; %width of the channel
%n = 101; %amount of discretization
k_therm = 0.6; % thermal conductivity J/s/m/K
Ta = 300; % Ambient Temperature K
I0 = 30e4; %J/m3/s


y = linspace(0,w,n); %initialize the vector of ys   
dely = w/(n-1);      

% vectors of unknowns
u0 = zeros(2*n,1); %The unknowns of the equation are n Is and n Ts

%if an initial guess for u is not given
if (nargin == 3) 
    for i=1:n
        u0(i) = I0;
        u0(n+i) = Ta;
    end
elseif (nargin == 4)   %if initial guess is given then initialize the vector using that
    for i=1:n
        u0(i) = u_in(i);
        u0(n+i) = u_in(i+n);
    end
end


%options=optimset('Display','iter','MaxIter',500,'MaxFunEvals',100000);
options=optimset('MaxIter',500,'MaxFunEvals',100000);
u = fsolve(@fun,u0,options,I0,Ta,dely,k_therm,n,e0,e1);

return;

%//**********************************************************************


function f = fun(u,I0,Ta,dely,k_therm,n,e0,e1)
f = zeros(2*n,1);

%boundary condition for intensity
f(1) = u(1) - I0;

%I does not have a second boundary condition
f(n) = u(n) - u(n-1) - calc_ep(u(n+n),e0,e1)*u(n)*dely;

%boundarry conditions for temperature
f(n+1) = u(n+1) - Ta;
f(2*n) = u(2*n) - Ta;

for i=2:n-1
    f(i) = u(i) - u(i-1) - calc_ep(u(i+n),e0,e1) *u(i)*dely;
    f(i+n) = u(i+n-1) - 2*u(i+n) + u(i+n+1) - calc_ep(u(i+n),e0,e1)*u(i)*dely^2/k_therm;
end

return;


%//***********************************************************
% calculate the epsilon
function epsilon = calc_ep(T,e0,e1)
epsilon = e0 + e1*T^2;
return;
%//***********************************************************