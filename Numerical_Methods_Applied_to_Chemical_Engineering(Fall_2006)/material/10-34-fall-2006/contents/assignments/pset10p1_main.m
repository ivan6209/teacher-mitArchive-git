% 10.34 - Fall 2006
% HW Set #10
% Prof. Green and Rob Ashcraft
% 11/26/2006

% This problem is a Monte Carlo sampling of molecular geometries within a
% given molecular potential.  We want to compute a number of quantities,
% including the <1/R_HH^6> and <R_HH> for a number of temperatures.
% 
% The parameters in this code are the number of MC steps (N), the
% temperature values at which to calculate results (T_vec), and the maximum
% step size (del) in the +/- direction in cartesian coordinates.

clear; clc;

time_in = cputime;

N = 100000;  % number of MC steps
T_vec = [300; 600; 1000; 5000];  % temperature values to run at
del = 0.10;  %maximum step size, Angstroms

% determine the equilibrium structure via minimization of the V(q)
q_init = [1;1;1;1;1;1];
options = optimset('display','iter','TolX',1e-5,'TolFun',1e-10);
[q_equil] = fminunc(@V,q_init,[]);
invR6_equil = RHH_6(q_equil);   % calculate the <1/R^6> value for equilibrium using RHH_6 function
R_HH_equil = (1/invR6_equil)^(1/6);  % since there is only one value, we can use this formula to get R_HH

disp('  ');
disp('  ');
disp('Equilibrium value at 0 K:')
disp(['<R_HH> = ',num2str(R_HH_equil),' (Angstroms)']);
disp(['<1/R_HH^6> = ',num2str(invR6_equil),' (1/A^6)']);

%all x,y,z in Angstroms for the equilibrium geometry
xO1 = 0;
yO1 = 0;
zO1 = 0;

xO2 = q_equil(1);  
yO2 = 0;
zO2 = 0;

xH1 = q_equil(2); 
yH1 = q_equil(3);
zH1 = 0;

xH2 = q_equil(4); 
yH2 = q_equil(5); 
zH2 = q_equil(6);

% equilibrium structure and plotting
X = [xH1,xO1,xO2,xH2];
Y = [yH1,yO1,yO2,yH2];
Z = [zH1,zO1,zO2,zH2];

figure;
stem3(X,Y,Z+1,'-','linewidth',2); hold on;
plot3(X,Y,Z+1,'.-r','linewidth',4,'markersize',50); grid on;
title('Equilibrium Geometry at T = 0 K');
axis([min(X)-.5 max(X)+.5   min(Y)-.5 max(Y)+.5   0 max(Z+1)+.5 ]);
text(X(1)+0.2, Y(1)+0.2, Z(1)+1.2,'H_1')
text(X(2)+0.2, Y(2)+0.2, Z(2)+1.2,'O_1')
text(X(3)+0.2, Y(3)+0.2, Z(3)+1.2,'O_2')
text(X(4)+0.2, Y(4)+0.2, Z(4)+1.2,'H_2')


disp('  ');
disp('  ');
disp(['Number of MC steps taken: ',num2str(N)]);

% Run the MC simulation for each temperature and generate some plots.
for t=1:length(T_vec)
    T = T_vec(t);
    
    % Perform the Monte Carlo steps for each of the temperature values
    [fAverage(:,t),accepted,q_all,f_val,f_val_sqr,RHH_val,X_all,Y_all,Z_all,V_all] = Metropolis(@RHH_6,T,q_equil,N,del);

    % estimate the uncertainty from the fluctuations
    uncertainty(t,1) = sqrt( 1/N*(sum(f_val_sqr)/N - (sum(f_val)/N)^2) );
    
    % estimate the uncertainty by taking the standard deviation of the
    % <1/R_HH^6> values for the final 50% of the MC points
    StDev(t,1) = std(fAverage(end/2:end,t));
    
    disp('  ');
    disp(['<1/R_HH^6> for T = ',num2str(T_vec(t)),' K:  ',num2str(fAverage(end,t)),'  +/-  ',num2str(uncertainty(t))]);
    disp(['<1/R_HH^6> for T = ',num2str(T_vec(t)),' K:  ',num2str(fAverage(end,t)),' with sigma = ',num2str(StDev(t))]);
    disp(['<R_HH> for T = ',num2str(T_vec(t)),' K:  ',num2str(mean(RHH_val))]);
    disp(['There were ',num2str(accepted),' steps accepted out of ',num2str(N),' total steps']);
    disp('  ');


    % Generate some plots, 3-D geometry plots and histograms
    figure;
    plot3(X,Y,Z,'.-r','linewidth',4,'markersize',50); grid on;
    hold on;
    plot3(X_all,Y_all,Z_all,'.');
    hold off;
    title(['Results for T = ',num2str(T),' K and ',num2str(N),' MC steps']);


    figure;
    subplot(1,2,1);
    hist(RHH_val,linspace(min(RHH_val),max(RHH_val),round((max(RHH_val)-min(RHH_val))/0.01)));
    axis([0 5 0 1]); axis 'auto y';
    ylabel('Frequency'); xlabel('H-H Distance (A)');
    title(['H-H Distr. for T = ',num2str(T),' K and ',num2str(N),' MC steps']);
    
    subplot(1,2,2);
    hist(V_all,50);
    xlabel('Potential Energy (pJ)');
    
    set(get(0,'CurrentFigure'),'position',[288   595   1344   503]);
    title(['Potential Distr. for T = ',num2str(T),' K and ',num2str(N),' MC steps']);

    [n_V,V_bin] = hist(V_all,50);
    
    % find the most frequent V(q) value from the histogram
    [val,loc] = max(n_V);
    V_max = V_bin(loc);
    
    disp(['Most probable MC V(q) = ',num2str(V_max),' pJ']);
    disp(['Value of kB*T = ',num2str(1.3807e-23*T*1e12),' pJ']);
    disp(['Time up to now = ',num2str(cputime-time_in),' seconds']);
    disp('  ');
    
    pause(2);
end

% plot the progression of the <1/R_HH^6> value as the # steps increases
N_vec = linspace(1,N,N);
figure;
plot(N_vec,fAverage(:,1),'-',N_vec,fAverage(:,2),':',...
    N_vec,fAverage(:,3),'-.',N_vec,fAverage(:,4),'--')
title(['Results for ',num2str(N),' MC steps']);
xlabel('Step Number'); ylabel('Cummulative <1/R_H_H^6> Value  (A^-^6)');
legend('T = 300 K','T = 600 K','T = 1000 K','T = 5000 K');




