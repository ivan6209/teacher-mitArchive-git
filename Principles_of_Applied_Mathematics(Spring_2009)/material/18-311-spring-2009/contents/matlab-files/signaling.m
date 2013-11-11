%% Signaling problem: u_tt = c^2*u_xx, u(x,0) = u_t(x,0) = 0, x>0, t>0 
%  and a given boundary conditions at x=0: u(0,t) = r(t)
% A. Kasimov, MIT 18.311, S2009
% To run the script, press Cmd-Enter
clear all; clf

c = 1;   %wave speed
L = 20;  %domain length
tend = 30; dt = 0.3; %plot every dt time intervals until t=tend
trange = 0:dt:tend; %generate the solution at trange
x = linspace(0,L,1000);  %the x-axis data

set(gca,'nextplot','replacechildren')
xlabel 'x', ylabel 'u'

%the boundary-displacement function, r(t)
r = @(t) 0.5*sin(3*t).*cos(4*t);

disp('Creating the movie...');
mov = avifile('signaling.avi');

k = 0;
for t = trange,
    k = k + 1;
    u = r(t - x/c).*(x<c*t);
    plot(x,u,'-','LineWidth',2),  grid on;
    axis([0 L -1 1]);
    title(['Signaling solution at t = ',num2str(round(t))]);
    text(1,0.85,'u_{tt} = c^{2}u_{xx}, u(x,0)=u_{t}(x,0)=0, x>0, t>0','FontSize',10,'FontWeight','bold')
    text(1,0.65,'u(0,t)=r(t)=0.5sin(3t)cos(4t). Solution: u(x,t)=H(t-x/c)r(t-x/c)','FontSize',10,'FontWeight','bold')
    getframe;
    Frame(k) = getframe(gcf);
    mov = addframe(mov,Frame(k));
end

mov = close(mov);