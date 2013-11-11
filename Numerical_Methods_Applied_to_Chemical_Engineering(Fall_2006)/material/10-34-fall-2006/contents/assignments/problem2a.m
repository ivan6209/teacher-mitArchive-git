function T=problem3a()
% function to solve the BVP d2T/dy2 + G = 0
% written by Sandeep Sharma 09/19/2006

w = 0.01; %width of the channel
n = 101; %amount of discretization
k_therm = 0.6; % thermal conductivity J/s/m/K
Ta = 300; % Ambient Temperature K
I0 = 30e4; %J/m3/s
I = I0*0.1;

y = linspace(0,w,n); 
b = zeros(n,1);
dely = w/(n-1);

A=spalloc(n,n,3*n); %use the fact the A is a highly sparce banded matrix 
%Boundary conditioon
A(1,1) = 1; b(1) = Ta;
A(n,n) = 1; b(n) = Ta;

for i=2:n-1 
    A(i,i) = -2;
    A(i,i+1) = 1;
    A(i,i-1) = 1;
    b(i) = -I*dely^2/k_therm/w;
end

T = A\b;

plot(100*y,T);
title('Temperature as a function of width for uniform laser absorption');
xlabel('width (cm)');
ylabel('Temperature (K)');

[T_max,index] = max(T);
output = strcat('The maximum temperature is T = ',num2str(T_max),' K\n');
fprintf(output);
output = strcat('The y-value at which temperature is maximum = ',num2str(y(index)*100),' cm\n');
fprintf(output);
return;

