function problem3_bvp(k_input)
%solves the problem 3 of hw 8 (6.C.5 in beers book)

% clear all;
% clc;

nz = 20; %number of grid points in the z direction
ny = 25; %number of grid points in the y direction
k = k_input; %rate constant in 1/M/s
K = 1e3; %equilibrium constant
Ha = 1e3; %henrys constant for A mol/m^3/atm
pa = 1e-4; %partial pressure of A
mu = 1e-3; %viscosity of water
rho = 1e3; %density of water
Da = 1e-5; %diffusivity of A
Db = 1e-5; %diffusivity of B
Dc = 1e-5; %diffusivity of C
b = 0.1; %width of channel
L = 50; %length of channel
theta = 80; %incline of the channel
cb_init = 1;%concentration of b  in the reservoir



%initialize the grid points on y direction
for i=1:20
    y_i(i) = (i-1)*0.01/19;
end
for i=21:ny
    y_i(i) = 0.01 + (b-0.01)/(ny-20)*(i-20);
end


%intitialize the grid points on z direction
for i=1:10
    z_i(i) =  (i-1)*5/(10-1);
end
for i=11:20
    z_i(i) = 5+ (i-10)*(L-5)/(nz-10);
end


%populate the params
params.nz = nz;params.k = k; params.K = K; params.Ha = Ha; 
params.pa = pa; params.mu = mu; params.rho = rho; params.Da = Da; 
params.Db = Db; params.Dc = Dc; params.b = b; 
params.L = L; params.theta = theta; params.cb_init = cb_init;
params.ny = ny; params.z_i = z_i; params.y_i = y_i;

%give the initial guesses of the profiles of each species
ca0 = pa*Ha*ones(ny*(nz),1);
cb0 = cb_init*ones(ny*(nz),1);
cc0 = zeros(ny*(nz),1);

%make a initial guess vector with all concentrations one below the other
c_guess = [ca0;cb0;cc0];

%solve the system of equations
options = optimset('Display','iter');
c = fsolve(@solve_c_nonuniformgrid,c_guess,options,params);

%get concentrations of individual species from the ouput concentration
%vector
ca = c(1:ny*(nz));
cb = c(ny*(nz)+1:2*ny*(nz));
cc = c(2*ny*(nz)+1:3*ny*(nz));

%make concentration matrices for each species so that they can be plotted
ca_matrix = array_to_matrix(ca,ny,nz);
cb_matrix = array_to_matrix(cb,ny,nz);
cc_matrix = array_to_matrix(cc,ny,nz);

%plot the concentration of each species 
pcolor(y_i',z_i',ca_matrix);xlabel('y-axis (cm)'); ylabel('z-axis (cm)');title('Concentration of A');shading interp;colorbar;%zlabel('Concentration of A (mol/cm3)');
figure; pcolor(y_i',z_i',cb_matrix);xlabel('y-axis (cm)'); ylabel('z-axis (cm)');title('Concentration of B');shading interp;colorbar;%zlabel('Concentration of B (mol/cm3)');
figure; pcolor(y_i',z_i',cc_matrix);xlabel('y-axis (cm)'); ylabel('z-axis (cm)');title('Concentration of AB');shading interp;colorbar;%zlabel('Concentration of AB (mol/cm3)');


%calculate the flux of A
flux = 0;
for i=2:nz
    fi = (-3*ca_matrix(i,1)+4*ca_matrix(i,2)-ca_matrix(i,3))/(y_i(2)-y_i(1))/2;
    fi_1 = (-3*ca_matrix(i-1,1)+4*ca_matrix(i-1,2)-ca_matrix(i-1,3))/(y_i(2)-y_i(1))/2;
 flux = flux + -Da/1000*(fi+fi_1)/2*(z_i(i)-z_i(i-1))/L;
end
output = strcat('The total flux of A into the channel is:\t', num2str(flux),'\t mol/cm^2/s\n');
fprintf(output);
return;
