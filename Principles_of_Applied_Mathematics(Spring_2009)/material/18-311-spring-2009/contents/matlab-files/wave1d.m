%% Fourier series solution of: u_tt = c^2*u_xx, u(x,0) = f(x), u_t(x,0) = g(x)
%and homogeneous boundary conditions at x={0,L}.
%case  i): f(x) = max{0, 1 - |x-L/2|/l}, g(x) = 0
%case ii): f(x) = 0, g(x) = 1/2l, if |x-L/2|<l and g(x) = 0 otherwise
%A. Kasimov, MIT 18.303, Fall 2007
%To run the script, press Ctrl-Enter
clear all; clf

c = 1;   %wave speed
L = 20;  %domain length
l = 1; %size of the initial profile
nmax = 200; %number of terms in the Fourier series

tend = 30; dt = 0.1;
trange = 0:dt:tend; %generate the solution at trange
x = linspace(0,L,1000);  %the x-axis data

set(gca,'nextplot','replacechildren')
xlabel 'x', ylabel 'u'

problem = 'i';
filename = ['case-',problem];

switch problem
    case 'i'
        %----------------------the solution for case i):-------------------
        disp('Creating the movie...');
        mov = avifile('wave1d-i.avi');
        %the Fourier coefficients
        bn = @(n) 0;
        an = @(n) 4*L/(pi^2*l)/n^2*sin(n*pi/2)*(1 - cos(n*pi*l/L));
        %The term in the Fourier series
        un = @(n,x,t) ( an(n)*cos(n*pi*c*t/L) + bn(n)*sin(n*pi*c*t/L) ).*sin(n*pi*x/L);

        k = 0;
        for t=trange,
            k = k + 1;
            u = zeros(size(x));
            for nn=1:nmax, u = u + un(nn,x,t); end  %The Fourier sum
            plot(x,u,'-','LineWidth',2),  grid off;
            axis([0 L -1 1]);
            title(['Plucked string at t = ',num2str(round(t))]);
            text(1,0.9,'u_{tt} = c^{2}u_{xx}, u(x,0)=max(0,1-|x-0.5L|/l), u_{t}(x,0)=0','FontSize',10)
            text(1,0.75,'u(x,t) = \Sigma_{n=1}^{\infty}a_{n}cos(n\pict/L)sin(n\pix/L)','FontSize',10)
            text(1,0.6,'a_{n} = 4L/(\pi^{2}l n^{2})sin(n\pi/2)(1 - cos(n\pil/L)','FontSize',10)
            
            Frame(k) = getframe(gcf); 
            mov = addframe(mov,Frame(k));
        end
        
  mov = close(mov);
  case 'ii'
        %----------------------the solution for case ii):------------------
        disp('Creating the movie...');
        mov = avifile('wave1d-ii.avi');
        %the Fourier coefficients 
        an = @(n) 0;
        bn = @(n) 2*L/(pi^2*c*l)/n^2*sin(n*pi/2)*sin(n*pi*l/L);
        un = @(n,x,t) ( an(n)*cos(n*pi*c*t/L) + bn(n)*sin(n*pi*c*t/L) ).*sin(n*pi*x/L);

        k = 0;
        for t=trange,
            k = k + 1;
            u = zeros(size(x));
            for nn=1:nmax, u = u + un(nn,x,t); end  %The Fourier sum
            plot(x,u,'-','LineWidth',2),  grid on;
            axis([0 L -1 1]);
            title(['Struck string at t = ',num2str(t)]);

            Frame(k) = getframe(gcf); 
            mov = addframe(mov,Frame(k));
        end
  mov = close(mov);

end