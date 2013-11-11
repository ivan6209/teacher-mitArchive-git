function [t,h]=pset7problem1
%solves the problem 4.B.1 in Beer's textbook
%input : none
%output: returns time t and height h of the tank

%initialize the parameters
params.rho = 1000; %SI units
params.mu = 0.001; %SI units
params.Dp = 0.01; %SI units
params.KL = 0.2;
params.Lp = 0.2; %SI units

h0 = 2; %initial value of h in m

options = odeset('Events', @odeevent,'RelTol',1e-4,'AbsTol',1e-14);
[t,h, TE, YE, IE] = ode23s(@odefun, [0 10000], h0,options,params);

plot(t,h); title('The height in the tank');
xlabel('Time (sec)'); ylabel('Height (m)');ylim([0.0 2.1]);

output = strcat('The tank gets empty at time:\t',num2str(TE),' s\n');
fprintf(output);

%calculates the volume in the tank for an array of given heights
V = calculateVolume(h);

figure;
plot(t,V);title('The volume of water in tank');
xlabel('Time(sec)'); ylabel('Volume (m^3)');;
return;

%*************************************************************************


function f = odefun(t,h,params)
%calculates the dhdt 

f = 0;

%solve the value of dhdt
option = optimset('Display','off');
if (h<=0)
    dhdt = 0;
elseif (h>=2.0001)
    dhdt = 0;
else
    dhdt = fsolve(@fsolvefun, 1.26e-3,option,h,params);
end

f = -1*abs(dhdt);
return

%*************************************************************************

function residue = fsolvefun(dhdt,h,params)
%unpack the parameters
rho = params.rho;

%calculate the drain velocity
vp = v_drain(h,dhdt, params);


%calculate the frictionfactor
f = ff(h, dhdt, params);

Lp = params.Lp;
KL = params.KL;
Dp = params.Dp;


residue = 1/2*dhdt^2 + 9.8 * h - vp^2/2 + 9.8*Lp - KL * (1/2*vp^2) - f * (Lp/Dp) * (1/2*vp^2);


return;


%*************************************************************************

function f = ff(h, dhdt, params)
%caclulates the friction factor

%calculate the drain velocity
vp = v_drain(h,dhdt, params);


%calculate the reynolds number
Re = Reynolds(vp, params);
option = optimset('Display','off');
if (Re < 2100)
    f = 64/Re;
elseif (Re >4000)
    f = fsolve(@solvef, 3.1e-2,option,Re,params);
    %fprintf('The Reynolds number are greater than 4000\n');
else
    f = 64/Re; %this will print a error message
    fprintf('The Reynolds number is between 2100 and 4000\n');
end

return;
 


%*************************************************************************

function vp = v_drain(h, dhdt, params)
%returns the drain velocity vp

%unpack the parameters
rho = params.rho;
mu = params.mu;
Dp = params.Dp;

d = (diameter(h));

vp = (d^2/Dp^2)*abs(dhdt);
return;

%*************************************************************************

function Re = Reynolds(vp, params)
%calculates the reynolds number

%unpack the parameters
rho = params.rho;
mu = params.mu;
Dp = params.Dp;

Re = rho * vp * Dp/mu;
return;


%*************************************************************************

function V = calculateVolume(h_given)
%for a given array of heights it returns an array of volumes.

for i = 1:length(h_given)
    h(length(h_given)-i+1) = h_given(i);
end

[h_out,V_calc] = ode45(@diffVdh,h,0,[]);

V = zeros(length(V_calc),1);
for i = 1:length(V_calc)
    V(i) = V_calc(length(V_calc)+1-i);
end

return;

%*************************************************************************

function f = diffVdh(h,V);

d = diameter(h);

f = pi*d^2/4;
return;

%*************************************************************************

function d = diameter(h)
%calculate the diameter at a given h

if (h < -0.000001)
    d = 35;
    fprintf('The height cannot be less than 0 \n height is:\t',num2str(h),' m\');

elseif(h <= 0.5)
    d = 35;
elseif(h > 0.5 && h<=0.75)
    d = 35 +  5 * (h-0.50)/0.25;
elseif(h > 0.75 && h<=1)
    d = 40 + 15 * (h-0.75)/0.25;
elseif(h > 1 && h<=1.25)
    d = 55 + 30 * (h-1.00)/0.25;
elseif(h > 1.25 && h<=1.50)
    d = 85 + 15 *(h-1.25)/0.25;
elseif(h>1.50 && h<=2.00001)
    d = 100;
else
    d = 100;%this will print an error message
    fprintf('The height cannot be greater than 2 m \n');
    fprintf('The height is:\t',num2str(h),' m\');
end

d = d/100; %convert to SI units

return

%*************************************************************************

function r = solvef(f,Re,params)

Dp = params.Dp;

r = 1/f^0.5 + 2*log10(0.045e-3/Dp/3.7 + 2.51/Re/f^0.5);
return;

%************************************************************************

function [value,isterminal,direction] = odeevent(t,x,params)
%is the events function used in ode23s which stops the integration as soon
%as h becomes less than 0.

isterminal(1) = 1;
direction(1) = 0;
value(1) = x;

return

%************************************************************************