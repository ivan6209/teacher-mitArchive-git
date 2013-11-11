% 10.34 - Fall 2006
% HW Set #11 - Kinetic Monte Carlo (Gillespie's Algorithm)
% Rob Ashcraft
% 12/10/2006

% Post-processing file for use with HW Set#11
% To use this, first open the *.mat file associated with this problem set.
% This has all of the save variables from the actual Monte-Carlo run.
% Opening this file will place them in the "workspace".  Then this code can
% be run to generate the results for the problem set.  This way the entire
% MC simulation does not need to be run again, since it takes a long time.

function p1_postprocessing()
clear; clc;

% load variable from the MC runs; the first is for part 2, second for part 3
load workspace_12-10-06_1hr.mat;
load workspace_partC_30min.mat time_fail_final_250 rate_fail_final_250 k_vec_partC;

% the first part here solves the continuum problem for the various D and k
Nav = 6.022e23;

time_0 = cputime;

line_style_vec = {'o','-','.','--','d',':','^','-.','x','+','s'};  % used in plotting
color_vec = {'k','b','r','g','k','b','r','g','k','b','r','g'};  % used in plotting

D_vec = [30; 50; 100; 250; 500; 1000; 2500];   % droplet diameter in nm
k_vec = [1; 10; 100];   % k-value from rate 4, in nm/sec

% initial conditions
C_ROO_0 = 0;        % molar
C_ROOH_0 = 1e-6;    % molar
C_RH_0 = 10;        % molar, constant value
C_O2_0 = 1e-4;      % molar, constant value

Temp = 313;            % Kelvin, constant value

C_ROOH_cutoff = 0.010;      % concentration at which to end simulation

% Determine the average number of molecules per droplet; print to screen
disp('Initial number of molecules of: ROO, ROOH, RH, and O2 in droplet of size D');
for i=1:length(D_vec)
    [N_ROO_0,N_ROOH_0,N_RH_0,N_O2_0] = calc_N(C_ROO_0,C_ROOH_0,C_RH_0,C_O2_0,D_vec(i));
    disp(['Droplet size (nm): ',num2str(D_vec(i)),' -- ROO = ',num2str(N_ROO_0),...
        ',  ROOH = ',num2str(N_ROOH_0),',  RH = ',num2str(N_RH_0),',  O2 = ',num2str(N_O2_0)]);
    legend_D{i,1} = ['D = ',num2str(D_vec(i)),' nm'];
end
disp('  ');

% Solve the continuum problem at a number of different Diameters and k's
odesteps_small = 500;    % this is used in the plots
odesteps_large = 10000;  % this is used to find the the time to failure
% integrate to 24 hrs.  An event function could also be used.  
t_small = linspace(0,3600*24,odesteps_small);   
t_large = linspace(0,3600*24,odesteps_large);
options = [];

for j=1:length(k_vec)
    figure; hold on;  % make a figure for each k-value
    for i=1:length(D_vec)
        [time(:,i,j),C(:,(i-1)*2+1:(i-1)*2+2,j)] = ode15s(@continuum_solver,t_large,[C_ROO_0,C_ROOH_0],options,Temp,D_vec(i),k_vec(j),C_RH_0,C_O2_0);
        [time_plot(:,i,j),C_plot(:,(i-1)*2+1:(i-1)*2+2,j)] = ode15s(@continuum_solver,t_small,[C_ROO_0,C_ROOH_0],options,Temp,D_vec(i),k_vec(j),C_RH_0,C_O2_0);
        
        [loc] = find(C(:,(i-1)*2+2,j) >= C_ROOH_cutoff);  % find where the [ROOH] > [ROOH]_critical
        % find the time and rate for the continuum cases
        time_to_failure(i,j) = time(loc(1),i,j);
        rate_of_failure(i,j) = 1/time_to_failure(i,j);
        %plot the [ROOH] vs. Time for each of the D's on the same plot for each k
        plot(time_plot(:,i,j),C_plot(:,(i-1)*2+2,j),strcat(line_style_vec{i},color_vec{i}));
    end
    legend(legend_D,'Location','NorthWest');
    axis([0 max(time_to_failure(:,j))*1.1 0 0.015]); %axis 'auto y';
    xlabel('Time (sec)'); ylabel('[ROOH] in Molar');
    title(['Continuous Time Profiles for k = ',num2str(k_vec(j)),' nm/s']);
end

% plot the rate of failure for all cases on one plot
figure;
semilogx(D_vec,rate_of_failure(:,1),':o',D_vec,rate_of_failure(:,2),'--.',D_vec,rate_of_failure(:,3),'-*')
legend(['k = ',num2str(k_vec(1))],['k = ',num2str(k_vec(2))],['k =',num2str(k_vec(3))]);
xlabel('Droplet Diameter (nm)'); ylabel('Rate of Failure (1/sec)');
title('Continous Rate of Failure as f(D,k)');

% this part takes advantage of variables read from the MAT files.  This is
% stuff related to the kinetic MC runs for each diameter.  This section
% calculates the average time and rate of failure, the standard deviation,
% and confidence intervals for the droplets the reached the critical
% concentration.  It also commutes the ensemble average, which includes
% droplet that started with no ROOH or died out.
for i=1:length(D_vec)
    points(i) = length(time_fail_final{i});             % find the number of droplet that reached ROOH critical
    ln_avg_time(i) = mean(log(time_fail_final{i}));     % compute average time in log-space
    ln_stdev_time(i) = std(log(time_fail_final{i}));    % compute std. dev. of time in log-space
    avg_time(i) = exp(ln_avg_time(i));                  % compute the average time
    avg_time_plus(i) = exp(ln_avg_time(i) + ln_stdev_time(i));  % compute mean + 1 stdev
    avg_time_minus(i) = exp(ln_avg_time(i) - ln_stdev_time(i)); % compute mean - 1 stdev
    ln_ci_time(i) = tinv(.95,points(i)-1)*ln_stdev_time(i)/sqrt(points(i)); % compute the 99% CI for the mean
    avg_time_CIplus(i) = exp(ln_avg_time(i) + ln_ci_time(i));   % compute mean + 99% CI
    avg_time_CIminus(i) = exp(ln_avg_time(i) - ln_ci_time(i));  % compute mean - 99% CI
    
    % do the same as above, but for the rate of failure
    ln_avg_rate(i) = mean(log(rate_fail_final{i}));
    ln_stdev_rate(i) = std(log(rate_fail_final{i}));
    avg_rate(i) = exp(ln_avg_rate(i));
    avg_rate_plus(i) = exp(ln_avg_rate(i) + ln_stdev_rate(i));
    avg_rate_minus(i) = exp(ln_avg_rate(i) - ln_stdev_rate(i));
    ln_ci(i) = tinv(.95,points(i)-1)*ln_stdev_rate(i)/sqrt(points(i));
    avg_rate_CIplus(i) = exp(ln_avg_rate(i) + ln_ci(i));
    avg_rate_CIminus(i) = exp(ln_avg_rate(i) - ln_ci(i));
    lin_avg_rate(i) = mean(rate_fail_final{i});             % calculate the straight, linear mean for comparison
    
    % compute the ensemble average, including dead:
    all_dead(i) = started_dead(i) + started_but_died(i);    % all droplets that started with no ROOH, or died
    total(i) = points(i) + all_dead(i);                     % all droplets
    ensemble_avg_time(i) = points(i)*(avg_time(i)/total(i)) + all_dead(i)*(0/total(i));
    ensemble_avg_rate(i) = points(i)*(avg_rate(i)/total(i)) + all_dead(i)*(0/total(i));
    
    % print the above results to the command window
    disp('  ');
    disp(['For Diameter = ',num2str(D_vec(i)),' nm']);
    disp(['Number of steps that reached critical C_ROOH: ',num2str(length(N_ROOH_final{i}(:))),' of ',num2str(MC_steps(i)),' steps']);
    disp(['Went too long (but did not become stable): ',num2str(went_too_long(i)),' of ',num2str(alive(i)),' steps']);
    disp(['Number of droplets that became stable (but reacted initially): ',num2str(started_but_died(i)),' of ',num2str(alive(i))]);
    disp(['Fraction of droplets that started stable: ',num2str(started_dead(i)),' of ',num2str(MC_steps(i)),' (',num2str(started_dead(i)/MC_steps(i)*100),'%)']);
    disp('  ');
    disp(['Continuum Time to Failure Stats: ',num2str(time_to_failure(i)/3600),' hours, or ',num2str(time_to_failure(i),'%1.2e'),' seconds']);
    disp(['Mean Time to Failure (99% CI): ',num2str(avg_time_CIminus(i)/3600),' < ',num2str(avg_time(i)/3600),' < ',num2str(avg_time_CIplus(i)/3600),' hours']);
    disp(['Time to Failure Stats (+/- StDev): ',num2str(avg_time_minus(i)/3600),' < ',num2str(avg_time(i)/3600),' < ',num2str(avg_time_plus(i)/3600),' hours']);
    disp(['Time to Failure Stats (+/- StDev): ',num2str(avg_time_minus(i),'%1.2e'),' < ',num2str(avg_time(i),'%1.2e'),' < ',num2str(avg_time_plus(i),'%1.2e'),' seconds']);
    disp(['Ensemble Avg. Time (with stable drops): ',num2str(ensemble_avg_time(i)/3600),' hours, or ',num2str(ensemble_avg_time(i),'%1.2e'),' seconds']);
    disp('  ');
    disp(['Continuum Rate Failure Stats: ',num2str(rate_of_failure(i)*3600),' 1/hrs, or ',num2str(rate_of_failure(i),'%1.2e'),' 1/sec']);
    disp(['Arithmetic Mean Rate of Failure: ',num2str(lin_avg_rate(i)*3600),' 1/hrs']);
    disp(['Mean Rate of Failure (99% CI): ',num2str(avg_rate_CIminus(i)*3600),' < ',num2str(avg_rate(i)*3600),' < ',num2str(avg_rate_CIplus(i)*3600),' 1/hrs']);
    disp(['Rate of Failure Stats (+/- StDev): ',num2str(avg_rate_minus(i)*3600),' < ',num2str(avg_rate(i)*3600),' < ',num2str(avg_rate_plus(i)*3600),' 1/hrs']);
    disp(['Rate of Failure Stats (+/- StDev): ',num2str(avg_rate_minus(i),'%1.2e'),' < ',num2str(avg_rate(i),'%1.2e'),' < ',num2str(avg_rate_plus(i),'%1.2e'),' 1/sec']);
    disp(['Ensemble Avg. Rate (with stable drops): ',num2str(ensemble_avg_rate(i)*3600),' 1/hrs, or ',num2str(ensemble_avg_rate(i),'%1.2e'),' 1/sec']);
    disp('  ');
    disp('  ');
end

D_vec = [30; 50; 100; 250; 500; 1000; 2500];
k_vec = [1; 10; 100];

% this section generates histograms from the time and rate data.  Also
% overlaid are the average value and +/- 1 stdev.  There are a few things
% that had to be done to make the graphs pretty, especially since the
% log-spaced histogram is not a normal thing.  Essentially, this creates a
% histogram with log-spaced bins, then overlays the mean +/- 1 stdev on the
% plots by making a "vertical" line.  We make sure it is scaled properly,
% labeled, and the colors are nice.
for i=1:7
    N_bin = 100;
    figure;
    subplot(1,2,1);
    [freq,bin] = hist(time_fail_final{i}(:),logspace(3,8,N_bin));
    hist(time_fail_final{i}(:),logspace(3,8,N_bin));
    max_freq = max(freq);
    h = findobj(gca,'Type','patch');
    set(h,'FaceColor',[.6 .6 .6],'EdgeColor','k')
    h = findobj(gca,'Type','line');
    set(h,'linestyle','none','marker','none')
    hold on;
    plot([avg_time(i) avg_time(i)],[0 1e6],'-b',[avg_time_minus(i) avg_time_minus(i)],[0 1e6],':b',...
        [avg_time_plus(i) avg_time_plus(i)],[0 1e6],':b','LineWidth',2);    %,[mean(time_fail_final{i}) mean(time_fail_final{i})],[0 1e6],'-y'
    set(gca,'Xscale','log'); axis([1e3 1e8 0 max_freq*1.1]); 
    title(['Time to Failure Histogram for D = ',num2str(D_vec(i)),' nm'])
    xlabel('Time to Failure (seconds)');  ylabel('Frequency');
    clear freq bin;

    subplot(1,2,2);
    [freq,bin] = hist(rate_fail_final{i}(:),logspace(-8,-3,N_bin));
    hist(rate_fail_final{i}(:),logspace(-8,-3,N_bin));
    max_freq = max(freq);
    h = findobj(gca,'Type','patch');
    set(h,'FaceColor',[.6 .6 .6],'EdgeColor','k')
    h = findobj(gca,'Type','line');
    set(h,'linestyle','none','marker','none')
    hold on;
    plot([avg_rate(i) avg_rate(i)],[0 1e6],'-b',[avg_rate_minus(i) avg_rate_minus(i)],[0 1e6],':b',...
        [avg_rate_plus(i) avg_rate_plus(i)],[0 1e6],':b',[lin_avg_rate(i) lin_avg_rate(i)],[0 1e6],'--y',...
        'LineWidth',2);
    set(gca,'Xscale','log'); axis([1e-8 1e-3 0 max_freq*1.1]); 
    title(['Rate of Failure Histogram for D = ',num2str(D_vec(i)),' nm'])
    xlabel('Rate of Failure (1/seconds)');  ylabel('Frequency');
    clear freq bin;

    set(get(0,'CurrentFigure'),'position',[288   595   1344   503]);
end

% This creates a figure showing the convergence of the rate of failure from
% the continuous simulations with the MC sims as a function of diameter for
% k = 10.  The +/- 10% of the continuous solution is also shown.
figure;
plot(D_vec,rate_of_failure(:,2)*3600,'-ob',D_vec,ensemble_avg_rate*3600,'--.k',...
    D_vec,rate_of_failure(:,2)*3600*0.9,':b',D_vec,rate_of_failure(:,2)*3600*1.10,':b');
xlabel('Droplet Diameter (nm)'); ylabel('Rate of Failure (1/hr)');
legend('Continuum Solution','Discrete MC Ensemble Average','+/- 10% of Continuum','Location','SouthEast');
title('Convergence of Discrete and Continuum Solutions');

% This is for part 3, which shows the dependence of the rate of failure on k.
% This is only for D = 250 nm, and includes the 99% CI on the mean.  We
% have to calculate the means and std. dev. again for these runs.  The
% k-values probed in this part ranged from 1 to 1000.
for i=1:length(k_vec_partC)
    L(i) = length(time_fail_final_250{i});
    ln_avg_time_250(i) = mean(log(time_fail_final_250{i}));
    ln_avg_rate_250(i) = mean(log(rate_fail_final_250{i}));
    ln_std_time_250(i) = std(log(time_fail_final_250{i}));
    ln_std_rate_250(i) = std(log(rate_fail_final_250{i}));
    ln_ci_250(i) = tinv(.95,L(i)-1)*ln_std_rate_250(i)/sqrt(L(i));
    
    ln_avg_rate_250_plus(i) = ln_avg_rate_250(i) + ln_ci_250(i);
    ln_avg_rate_250_minus(i) = ln_avg_rate_250(i) - ln_ci_250(i);
end
avg_rate_250 = exp(ln_avg_rate_250);

% Generate the figure.  
figure;
semilogx(k_vec_partC,avg_rate_250*3600,'.k',k_vec_partC,exp(ln_avg_rate_250_plus)*3600,'vb',...
    k_vec_partC,exp(ln_avg_rate_250_minus)*3600,'^b')
xlabel('k-value from Rate 4 (nm/sec)'); ylabel('Mean Rate of Failure(1/hrs)');
title('Part 3 - Dependence of Rate of Failure on k with 99% CIs');



%========================================
function dCdt = continuum_solver(time,C,T,D,k,C_RH,C_O2)

C_ROO = C(1);
C_ROOH = C(2);

rate1 = 1e15*exp(-15000/T)*C_ROOH;      % mole/L-s      ROOH + 2_RH + 2_O2 ==> 2_ROO + ROH + H2O
rate2 = 1e9*exp(-6000/T)*C_ROO*C_RH;    % mole/L-s      ROO + RH + O2 ==> ROOH + ROO
rate3 = 1e6*C_ROO^2;                    % mole/L-s      2_ROO ==> ROH + aldehyde + O2
rate4 = 0.10/D*k*C_ROO;    % D in nm    % mole/L-s      ROO + X(aq) ==> ROOH + X_dot(aq)

dROO_dt = 2*rate1 - 2*rate3 - rate4;
dROOH_dt = -rate1 + rate2 + rate4;

dCdt = [dROO_dt; dROOH_dt];
return;


%=========================================
function [N_ROO,N_ROOH,N_RH,N_O2] = calc_N(C_ROO,C_ROOH,C_RH,C_O2,D)

% diameter should be in nanometers and the concentration in moles/liter
Nav = 6.022e23;
% number of molecules in the droplet: N = C*Nav*pi/6*D^3*(1 dm^3/10^24 nm^3)
N_ROO = (C_ROO*Nav*pi/6*D^3)/1e24;
N_ROOH = (C_ROOH*Nav*pi/6*D^3)/1e24;
N_RH = (C_RH*Nav*pi/6*D^3)/1e24;
N_O2 = (C_O2*Nav*pi/6*D^3)/1e24;

return;