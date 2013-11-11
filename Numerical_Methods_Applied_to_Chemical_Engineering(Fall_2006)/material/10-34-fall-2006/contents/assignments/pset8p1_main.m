% 10.34 - Fall 2006
% Hw Set #8 - Problem #1
% Rob Ashcraft - Oct. 25, 2006


% Heat transfer to a laminar flow in a tube, without neglecting axial
% heat conduction.

%function pset8p1_main

clear; clc;

% Peclet number (Pe) = 2*U*R/a = 2*U*R*rho*Cp/lambda

Re = 100;

T0 = 300;  % K
T1 = 400;  % K
Cp = 4000;  % J/kg-K
lam = 0.6;  % W/m-K = J/m-s-K
mu = 0.5e-3;  % N-s/m^2
rho = 1000;  % kg/m^3

alpha = lam/rho/Cp  % thermal diffusivity (m^2/s)

R = 0.050;  % m

U = Re*mu/(2*R*rho)  % m/s

Pe = 2*U*R/alpha   % Peclet number

tau_cond = R^2/(2*alpha)   % sec

Nr = 21;
Nz = 201;
N_total = Nz*Nr;

Nup = 0.1;
Ndown = 2;
% actual variables
% take X tau's worth of U_centerline
z_initial = -Nup*2*U*tau_cond   %meters, start 2 tau's upstream
z_final = Ndown*2*U*tau_cond   %meters, go 10 tau's downstream

dz = (z_final - z_initial)/(Nz-1);
dr = R/(Nr-1);

% dimensionless variables
zeta_initial = -Nup;   %start 2 tau's upstream
zeta_final = Ndown;   %go 10 tau's downstream

dzeta = (zeta_final - zeta_initial)/(Nz-1);
deta = 1/(Nr-1);

A_sparse = spalloc(N_total,N_total,5*N_total);
b_vec = zeros(Nr*Nz,1);

for i = 1:Nz
    for j = 1:Nr
        
        % set up the index
        n = inline('(i-1)*Nr + j','i','j','Nr');
        
        z_var(j,i) = z_initial + (i-1)*dz;
        r_var(j,i) = 0 + (j-1)*dr;
        
        z(i) = z_initial + (i-1)*dz;
        r(j) = 0 + (j-1)*dr;
        
        zeta = zeta_initial + (i-1)*dzeta;
        eta = 0 + (j-1)*deta;
        
        % set up the boundary conditions
        
        % Wall BC for R
        if(j == Nr  &&  (zeta_initial + (i-1)*dzeta) < 0)   % T0 at the wall
            A_sparse(n(i,j,Nr),n(i,j,Nr)) = 1;
            b_vec(n(i,j,Nr)) = 0;  % scaled variable - equivalent to T0
%         elseif(j == Nr && (zeta_initial + (i-1)*dzeta) < 1)             % T1 at the wall
%             A_sparse(n(i,j,Nr),n(i,j,Nr)) = 1;
%             b_vec(n(i,j,Nr)) = zeta;  % scaled variable - equivalent to T1
        elseif(j == Nr)             % T1 at the wall
            A_sparse(n(i,j,Nr),n(i,j,Nr)) = 1;
            b_vec(n(i,j,Nr)) = 1; %zeta/zeta_final;  % scaled variable - equivalent to T1
        end
        % Centerline BC: dT/dr = 0
        if(j == 1)             % dT/dr = 0  --> polynomial interpolation
            A_sparse(n(i,j,Nr),n(i,j,Nr)) = 1;
            A_sparse(n(i,j,Nr),n(i,j+1,Nr)) = -4/3;
            A_sparse(n(i,j,Nr),n(i,j+2,Nr)) = 1/3;
            b_vec(n(i,j,Nr)) = 0;
        end
        
        % z-direction BCs
        if(i == 1  && j > 1 && j < Nr)
            A_sparse(n(i,j,Nr),n(i,j,Nr)) = 1;
            b_vec(n(i,j,Nr)) = 0;  % scaled variable - equivalent to T0
        elseif(i == Nz  && j > 1 && j < Nr)
            %A_sparse(n(i,j,Nr),n(i,j,Nr)) = 1;
            %b_vec(n(i,j,Nr)) = 1;  % scaled variable - equivalent to T1
            A_sparse(n(i,j,Nr),n(i,j,Nr)) = 1;
            A_sparse(n(i,j,Nr),n(i-1,j,Nr)) = -4/3;
            A_sparse(n(i,j,Nr),n(i-2,j,Nr)) = 1/3;
            b_vec(n(i,j,Nr)) = 0;
        end
        
        % now set up the equations for the internal region
        if(i > 1 && i < Nz  &&  j > 1 && j < Nr)
            b_vec(n(i,j,Nr)) = 0;
            
            A_sparse(n(i,j,Nr),n(i,j+1,Nr)) = eta/deta^2 + 1/(2*deta);
            A_sparse(n(i,j,Nr),n(i+1,j,Nr)) = eta/(Pe^2*dzeta^2);
            A_sparse(n(i,j,Nr),n(i,j,Nr)) = -2*eta/deta^2 - 2*eta/(Pe^2*dzeta^2) - eta*(1-eta^2)/dzeta;
            A_sparse(n(i,j,Nr),n(i,j-1,Nr)) = eta/deta^2 - 1/(2*deta);
            A_sparse(n(i,j,Nr),n(i-1,j,Nr)) = eta/(Pe^2*dzeta^2) + eta*(1-eta^2)/dzeta;
            
        end
        
    end
end

%figure; spy(A_sparse)

theta_vec = A_sparse\b_vec;
%[theta_vec,flag,relres,iter] = gmres(A_sparse,b_vec,3,1e-12,10,[],[],[]);

resid = A_sparse*theta_vec - b_vec;

sum(resid)

theta = reshape(theta_vec,Nr,Nz);

Temp = 300 + theta*(100);

figure;
surf(z_var,r_var,theta); shading interp; colormap jet;

figure;
pcolor(z_var,r_var,Temp); colorbar; shading interp; colormap jet;

figure;contour(z_var,r_var,Temp,50); colorbar; shading interp; colormap jet;

figure;
plot(z,theta(0*(Nr-1)+1,:),'-',z,theta(0.2*(Nr-1)+1,:),'--',z,theta(0.4*(Nr-1)+1,:),':',...
    z,theta(0.6*(Nr-1)+1,:),'--',z,theta(0.8*(Nr-1)+1,:),':');
  
    
    
    
    
    
    