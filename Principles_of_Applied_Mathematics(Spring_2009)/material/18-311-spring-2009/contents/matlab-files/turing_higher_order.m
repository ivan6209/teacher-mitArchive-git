function turing
% Solve a Turing system of two reaction-diffusion equations with Neumann
% boundary conditions:
% u_t = D*u_xx + 1 - u + u^2*v
% v_t =   v_xx + 2 - u^2*v
% D is the diffusion coefficient and n is the mode number of perturbation
% of the uniform steady-state solution, (u, v) = (3, 2/9);
% Theoretical information on linear instability:
% 1. The system is linearly stable at any D if n<=5
% 2. The system is unstable to a band of frequencies n provided D < Dc ~=0.0026
% 3. Unstable modes are determined by the inequality 
%    D < (n^2 - 27)/( 3*n^2*(n^2 +9) )
% 4. When unstable, the system has a maximum growth rate at a frequency given by  
%    nc^2 = 2/3*[ -14*D +3*sqrt(3D + 6D^2 +3D^3) ]/[D*(1-D)], 
% which gives, if D<<1, that nc ~= (12/D)^(1/4).

% A numerical case: If D=0.001, then nc = 10; 

% All of this information can be tested with the numerical solution that
% follows.

D = 0.001; % choose D

m = 100;        % number of grid points on the computational domain
xmax = pi;      % domain length
h = xmax/(m-1); % grid size
x = h*(1:m)'-h; % grid, x(1)=0, x(m)=xmax

lam = 0.49;     % this must be less <= 0.5 for numerical stability 
dt = lam*h^2;   % time step for integration
tmax = 200;     % end computations at t = tmax
jmax = floor(tmax/dt);  
nplots = 200;   % create nplots data for plotting

% second-derivative matrix for Neumann boundary conditions
Bn  = toeplitz([2 -1 zeros(1,m-2)]);  Bn(1,2) = -2; Bn(m,m-1) = -2;  

%Initial condition
amp = 0.01;      % perturbation amplitude
n = 5;         % perturbation frequency for a single mode 
% different kinds of perturbations to play with
u = 3 + amp*cos(n*x);
v = 2/9 + amp*cos(n*x);

% u = 3 + amp/6*(cos(6*x) + cos(7*x) + cos(8*x) + cos(9*x) + cos(10*x) + cos(11*x));
% u = 3 + amp*(2/pi*x.*(x<pi/2) + 1*(x>pi/2) );
% v = 2/9+ 0*cos(n*x);

udata = u; vdata = v; tdata = 0;

plot(x,u,'-r',x,v,'-b','LineWidth',2),  grid on;
axis([0 xmax -inf inf]);

% time integration by 3rd order Runge-Kutta method
for j =1:jmax 
    t = (j-1)*dt;
    
    %step 1:
    Lun = - D/h^2*Bn*u + 1 - u + u.^2.*v;
    Lvn = - 1/h^2*Bn*v + 2 - u.^2.*v;
    
    u1 = u + dt*Lun;
    v1 = v + dt*Lvn;

    %step 2:
    Lu1 = - D/h^2*Bn*u1 + 1 - u1 + u1.^2.*v1;
    Lv1 = - 1/h^2*Bn*v1 + 2 - u1.^2.*v1;
    
    u2 = u1 + dt/4*(-3*Lun + Lu1);
    v2 = v1 + dt/4*(-3*Lvn + Lv1);
    
    %step 3:
    Lu2 = - D/h^2*Bn*u2 + 1 - u2 + u2.^2.*v2;
    Lv2 = - 1/h^2*Bn*v2 + 2 - u2.^2.*v2;
    
    u = u2 + dt/12*(-Lun - Lu1 + 8*Lu2);
    v = v2 + dt/12*(-Lvn - Lv1 + 8*Lv2);
    
    %end of RK3
    
    if(mod(j,nplots)==0) %current line plots and save data for surface plotting
        
        subplot(211), plot(x,u,'-r','LineWidth',2),  grid on;
        title(['Turing system at t = ',num2str(round((j-1)*dt))]);
        axis([0 xmax  -inf inf]);
        ylabel u
        
        subplot(212), plot(x,v,'-b','LineWidth',2),  grid on;
        axis([0 xmax  -inf inf]);
        xlabel x, ylabel v
        
        getframe;

        udata = [udata u];
        vdata = [vdata v];
        tdata = [tdata t];

    end
    
end

% generate the mesh in x-t plane
[xx tt] = meshgrid(x,tdata);

% plot the results
figure, contourf(xx,tt,udata','EdgeColor','none');
xlabel x, ylabel t, zlabel u, title 'u'
axis([0 xmax 0 tmax]), colorbar

figure, surfc(xx,tt,vdata','EdgeColor','none'); view(2)
xlabel x, ylabel t, zlabel v, title 'u'
axis([0 xmax 0 tmax -Inf Inf]), colorbar
