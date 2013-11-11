% 10.34 - Fall 2006
% HW Set#2, Problem #4a
% Rob Ashcraft - Sept. 11, 2006

% This function takes in a vector of progress variables and reactor
% temperatures and calculates the residual values at each combination.
% Then it plots the residual values as a surface, as well as a contour plot
% showing the zero contour of both equations.  The intersection of the zero
% contours is the solution to the problem for the given conditions.

%%%%%%%%%%%%%%%%%%%%%%%%%
function WGS_contour(z_vec,Tr_vec,P,Tin,x_in)

global Vreactor res_time R Rj A Ea dHrxn dSrxn Cp_vec h

Cp_in = Cp_vec*x_in;


x_CO_in = x_in(1);
x_H2O_in = x_in(2);
x_CO2_in = x_in(3);
x_H2_in = x_in(4);

PCOin = P*x_CO_in;
PH2Oin = P*x_H2O_in;
PCO2in = P*x_CO2_in;
PH2in = P*x_H2_in;

h = 1.2; %1.2e-3;  %W/K

for i=1:length(z_vec)
    for j=1:length(Tr_vec)
        z(i,j) = z_vec(i);
        Treactor(i,j) = Tr_vec(j);
        
        dGrxn = dHrxn - Treactor(i,j)*dSrxn;
        
        PCO = PCOin - z(i,j)*R*Treactor(i,j)/Vreactor;
        PH2O = PH2Oin - z(i,j)*R*Treactor(i,j)/Vreactor;
        PCO2 = PCO2in + z(i,j)*R*Treactor(i,j)/Vreactor;
        PH2 = PH2in + z(i,j)*R*Treactor(i,j)/Vreactor;

        rate = A*exp(-Ea/Rj/Treactor(i,j))*(PCO*PH2O - PH2*PCO2*exp(dGrxn/Rj/Treactor(i,j)))/(1 + (PCO/0.2));

        resid_mass(i,j) = z(i,j) - rate*res_time;

        resid_energy(i,j) = -dHrxn*rate - (P*Vreactor/R/Treactor(i,j))/res_time*(Cp_in*(Treactor(i,j)-Tin)) - h*(Treactor(i,j)-300);
        
        
    end
    if(rem(i,100) == 0)
        disp(['Completed ',num2str(i),' steps out of ',num2str(length(z_vec)),' in making the contour plot']);
    end
end

z_max = x_in(1)*P*Vreactor/R/Tin;

z_mat = z;

Conv_mat = (z)/z_max*100;
T_mat = Treactor;

figure;
[C,h] = contour(Conv_mat,T_mat,resid_mass,[0 0],'-.k');
text_handle = clabel(C,h);
set(text_handle,'BackgroundColor',[1 1 .6],...
    'Edgecolor',[.7 .7 .7]);
hold 'on'
[C2,h2] = contour(Conv_mat,T_mat,resid_energy,[0 0],'--b');
text_handle = clabel(C2,h2);
set(text_handle,'BackgroundColor',[1 1 1],...
    'Edgecolor',[.7 .7 .7]);
legend('Mass Balance Residual','Energy Balance Residual');
xlabel('CO conversion (%)'); ylabel('Reactor Temperature (K)');
title(['Zero-Residual Contours of the Reaction and Energy Balances for T_I_n = ',num2str(Tin),' K']);


figure;
Cm=(zeros(length(z_vec),length(z_vec),3));
mesh(Conv_mat,T_mat,resid_energy,Cm);
xlabel('CO conversion (%)'); ylabel('Reactor Temperature (K)');
title(['Residual Values for the Energy Balances for T_I_n = ',num2str(Tin),' K']);
axis([0 1 0 1 -1e7 1e7]); axis 'auto xy'; 

figure;
surf(Conv_mat,T_mat,resid_energy,'EdgeColor','none');
xlabel('CO conversion (%)'); ylabel('Reactor Temperature (K)');
title(['Residual Values for the Energy Balances for T_I_n = ',num2str(Tin),' K']);
colormap('hsv');
axis([0 1 0 1 -1e7 1e7]); axis 'auto xy';  caxis([-1e7 1e7]); colorbar;

figure;
surf(Conv_mat,T_mat,resid_mass,'EdgeColor','none');
xlabel('CO conversion (%)'); ylabel('Reactor Temperature (K)');
title(['Residual Values for the Mass Balances for T_I_n = ',num2str(Tin),' K']);
colormap('hsv');
axis([0 1 0 1 -1e2 1e2]); axis 'auto xy';  caxis([-1e0 1e0]); colorbar;

