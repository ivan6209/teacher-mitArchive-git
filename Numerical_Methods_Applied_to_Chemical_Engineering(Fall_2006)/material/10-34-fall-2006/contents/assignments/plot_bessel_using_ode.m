% problem 1, HW set 1
% Solution of bessel's equation function using ode23s.

function plot_bessel_using_ode(x_end)

%u_init is the intial condition at t=0
u_init = [1 0];

%solve the differential equation using ode23s to generate vectors for x and
%u.

[x,u]=ode23s(@diff,[0 x_end],u_init,[]);

plot(x,u(:,1));
title('Bessel function of first kind using solution from ode');
xlabel('x');
ylabel('y(x)');
return;

%function diff evaluates the derivatives of u1 ad u2.
function f = diff(x,u)

f = zeros(size(u));

f(1) = u(2);
if (x ==0)
    f(2)=-0.5;
else
    f(2) = -u(2)/x - u(1);
end

return;