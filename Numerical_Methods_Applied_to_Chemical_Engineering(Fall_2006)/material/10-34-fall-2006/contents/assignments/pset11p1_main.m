% 10.34 - Fall 2006
% HW Set #11 - Kinetic Monte Carlo (Gillespie's Algorithm)
% Rob Ashcraft
% 12/10/2006

% This function performs the continuous solution and the kinetic Monte
% Carlo solution for several diameters and k-values.  There are no inputs
% to this function, but they can be specified in the body of the function.
% Additional comment may be found in the file "p1_postprocessing.m". 

function pset11p1_main

clear; clc;
warning off all;
Nav = 6.022e23;

time_0 = cputime;

line_style_vec = {'o','-','.','--','d',':','^','-.','x','+','s'};
color_vec = {'k','b','r','g','k','b','r','g','k','b','r','g'};

D_vec = [30; 50; 100; 250; 500; 1000; 2500];
k_vec = [1; 10; 100];

% initial conditions
C_ROO_0 = 0;        % molar
C_ROOH_0 = 1e-6;    % molar
C_RH_0 = 10;        % molar, constant value
C_O2_0 = 1e-4;      % molar, constant value

Temp = 313;            % Kelvin, constant value

C_ROOH_cutoff = 0.010;      % concentration at which to end simulation

% see additional comments for the continous part
disp('Initial number of molecules of: ROO, ROOH, RH, and O2 in droplet of size D');
for i=1:length(D_vec)
    [N_ROO_0,N_ROOH_0,N_RH_0,N_O2_0] = calc_N(C_ROO_0,C_ROOH_0,C_RH_0,C_O2_0,D_vec(i));
    disp(['Droplet size (nm): ',num2str(D_vec(i)),' -- ROO = ',num2str(N_ROO_0),...
        ',  ROOH = ',num2str(N_ROOH_0),',  RH = ',num2str(N_RH_0),',  O2 = ',num2str(N_O2_0)]);
    legend_D{i,1} = ['D = ',num2str(D_vec(i)),' nm'];
end
disp('  ');
% Solve the continuum problem at a number of different Diameters and k's
odesteps_small = 500;
odesteps_large = 10000;
t_small = linspace(0,3600*24,odesteps_small);
t_large = linspace(0,3600*24,odesteps_large);
options = [];

for j=1:length(k_vec)
    %clear time C;
    %time = 
    figure; hold on;
    for i=1:length(D_vec)
        [time(:,i,j),C(:,(i-1)*2+1:(i-1)*2+2,j)] = ode15s(@continuum_solver,t_large,[C_ROO_0,C_ROOH_0],options,Temp,D_vec(i),k_vec(j),C_RH_0,C_O2_0);
        [time_plot(:,i,j),C_plot(:,(i-1)*2+1:(i-1)*2+2,j)] = ode15s(@continuum_solver,t_small,[C_ROO_0,C_ROOH_0],options,Temp,D_vec(i),k_vec(j),C_RH_0,C_O2_0);
        
        [loc] = find(C(:,(i-1)*2+2,j) >= C_ROOH_cutoff);
        time_to_failure(i,j) = time(loc(1),i,j);
        rate_of_failure(i,j) = 1/time_to_failure(i,j);
        
        
        plot(time_plot(:,i,j),C_plot(:,(i-1)*2+2,j),strcat(line_style_vec{i},color_vec{i}));
    end
    legend(legend_D,'Location','NorthWest');
    axis([0 max(time_to_failure(:,j))*1.1 0 0.015]); %axis 'auto y';
end

figure;
semilogx(D_vec,time_to_failure(:,1),'o',D_vec,time_to_failure(:,2),'.',D_vec,time_to_failure(:,3),'*')
legend(['k = ',num2str(k_vec(1))],['k = ',num2str(k_vec(2))],['k = ',num2str(k_vec(3))]);

%================================================================
% Now work on the Kinetic Monte Carlo part of the problem:
% I have this set somewhat specfically for my computer in terms of timing.
% That is, I can specify a total wall time I want to spend per D, and the
% code will choose the appropriate number of steps. You compute could run
% faster or slower than mine (likely faster).

t_per_D = 60;  % wall time you want to spend per droplet size, in seconds

% m gives the average time per MC trajectory run:  Time (sec) = m*N_traj
% these values will different on a different computer
m =  [1.85e-5;
      8.88e-5;
      0.0026;
      0.113;
      0.898;
      7.188;
      113.1];

% iterate over the different D-values
for i = 1:length(D_vec)
    % compute the number of MC steps.  This will be a non-round number, so
    % the next part will attempt to round it to a nice, round number
    MC_steps_temp(i) = t_per_D/m(i);
    
    places(i) = length(num2str(round(MC_steps_temp(i))));  % number of place left of decimal
    if(places(i) > 2)  % if N >= 100
        MC_steps(i) = ceil(MC_steps_temp(i)/(10^(places(i)-2))) * 10^(places(i)-2);  % round up to the 2nd place (e.g. 121 -> 130, 4567304 -> 4600000)
    elseif(places(i) == 2)   % if 10 < N < 100
        MC_steps(i) = ceil(MC_steps_temp(i)/10) * 10;  % round up to the nearest 10 (94 -> 100, 18 -> 20)
    else    % N < 10
        MC_steps(i) = ceil(MC_steps_temp(i));  % just round up (4.56 -> 5, 9.2123 -> 10)
    end
end

j=2;    % for k = 10
for i = 1:length(D_vec)
    time_in = cputime;  % this is for keeping track of wall time
    
    disp(['Now running MC simulation for D = ',num2str(D_vec(i)),' nm']);
    % For droplets that start with no ROOH or deplete all ROO + ROOH, just
    % keep track of them with a counter (also for droplets go longer than
    % my arbitrary upper time limit)
    started_dead(i) = 0;        % droplet that start with no ROOH
    started_but_died(i) = 0;    % droplet that start with 1+ ROOH, and get to a condition with no ROO + ROOH
    went_too_long(i) = 0;       % droplets don't reach critical concentration by upper time limit

    [N_ROO,N_ROOH,N_RH_0,N_O2_0] = calc_N(C_ROO_0,C_ROOH_0,C_RH_0,C_O2_0,D_vec(i));

    % defined vector sizes to make the code run faster.  This is very
    % important for large (>30000 elements) vectors where you are storing
    % data.  If you don't predefine the size, Matlab will grow the vector
    % for you, but it becomes slow for large vectors.  The idea here is to
    % pre-allocate memory for the vector for the number of elements.  If
    % you start with more than 2 ROOH, basically every step will yield a
    % finite time to failure.  In this case the vector size is the number
    % of MC steps.  When you start with an average ROOH less than ~2, you
    % can't prespecify the exact length, since some droplet will start dead
    % or die along the way.  In this case, I start with a vector slightly
    % larger than I would expect to get, and fill it with NaN.  This will
    % easily allow me to extract the meaningful later on.  I will alse make
    % sure to fill these vectors from the top down, with no spaces between
    % meaningful data.
    if(N_ROOH > 2)
        N_ROOH_temp{i} = zeros(MC_steps(i),1);      % vector to store final number of ROOH (a long vector in each of 7 cells, one per D)
        time_fail_temp{i} = zeros(MC_steps(i),1);   % vector to store time to failure
        rate_fail_temp{i} = zeros(MC_steps(i),1);   % vector to store rate of failure
    else        
        N_ROOH_temp{i} = zeros(MC_steps(i)*N_ROOH*1.25,1)*NaN;
        time_fail_temp{i} = zeros(MC_steps(i)*N_ROOH*1.25,1)*NaN;
        rate_fail_temp{i} = zeros(MC_steps(i)*N_ROOH*1.25,1)*NaN;
    end
    
    Vol = pi/6*D_vec(i)^3;  % volume in nm^3
    
    sizect = 0;   
    % "sizect" is a counter that will keep track of the droplets that reach
    % the critical concentration.  This will allow the vectors to be filled
    % from the top down, even though the MC_step counter does not
        
    % calculate the average number of molecules for a given drop size
    [N_ROO_0,N_ROOH_0,N_RH_0,N_O2_0] = calc_N(C_ROO_0,C_ROOH_0,C_RH_0,C_O2_0,D_vec(i));
           
    for mc = 1:MC_steps(i)   % run trajectories for each D

        % since the N_0's calculated from the concentrations will be non-integer,
        % we need to round them to the nearest integer based on a probability.
        % This is accomplished with the following lines:
        N_ROO = round(N_ROO_0 + (rand-.5));
        N_ROOH = round(N_ROOH_0 + (rand-.5));
        N_RH_0 = round(N_RH_0 + (rand-.5));
        N_O2_0 = round(N_O2_0 + (rand-.5));
        
        if(N_ROOH == 0)  % droplet start with nothing... do nothing
            started_dead(i) = started_dead(i)+1;  % keep track of the number that starts dead
            mctime = NaN;
            
        else  % N_ROOH >= 1  ... something will happen, so run MC
            
            % compute the rates of reation in units of molecules/sec-droplet
            % I found that writing the rates out explicitly (instead of
            % using a function call to a code that returns the rate speeded
            % up the code by ~10 times (in the while loop mainly)
            rates(1) = (1e15*exp(-15000/Temp)*N_ROOH/Vol)*Vol;                              % molecules/drop-s      ROOH + 2_RH + 2_O2 ==> 2_ROO + ROH + H2O
            rates(2) = (1e9*(1e24/6.022e23)*exp(-6000/Temp)*N_ROO/Vol*N_RH_0/Vol)*Vol;      % molecules/drop-s      ROO + RH + O2 ==> ROOH + ROO
            rates(3) = (1e6*(1e24/6.022e23)*(N_ROO/Vol)*((N_ROO-1)/Vol))*Vol;                       % molecules/drop-s      2_ROO ==> ROH + aldehyde + O2
            rates(4) = (0.10/D_vec(i)*k_vec(j)*N_ROO/Vol)*Vol;                      % D in nm       % molecules/drop-s      ROO + X(aq) ==> ROOH + X_dot(aq)

            tau = 1/(rates(1) + rates(2) + rates(3) + rates(4));  % compute the Tau under these droplet conditions
            
            mctime = 0;  % initially, the time in the MC simulation is zero, this variable keeps track of it
            
            C_ROOH = C_ROOH_0;  % the concentration starts out at some initial value (not actually this, but this is not really used)
            
            dead = 0;   % this keep track of if the drop dies.  if so, the while loop will break
            
            % this "while" runs the MC until one of three conditions is
            % satisfied:
            %  (1) The critical concentration is reached
            %  (2) The upper limit on time is reached
            %  (3) The droplet dies (all ROO and ROOH has reacted away)
            while(C_ROOH <= C_ROOH_cutoff  &  mctime <= 1e8  &  dead ~= 1)
                
                
                if(N_ROO + N_ROOH == 0)  % the droplet has died
                    dead = 1;  % this will make the while loop break
                    N_ROOH = N_ROOH;
                    N_ROO = N_ROO;
                elseif(N_ROO + N_ROOH ~= 0)   % the droplet still has active species present... keep stepping along in time     

                    rates(1) = (1e15*exp(-15000/Temp)*N_ROOH/Vol)*Vol;                           % molecules/drop-s      ROOH + 2_RH + 2_O2 ==> 2_ROO + ROH + H2O
                    rates(2) = (1e9*(1e24/6.022e23)*exp(-6000/Temp)*N_ROO/Vol*N_RH_0/Vol)*Vol;     % molecules/drop-s      ROO + RH + O2 ==> ROOH + ROO
                    rates(3) = (1e6*(1e24/6.022e23)*(N_ROO/Vol)*((N_ROO-1)/Vol))*Vol;                       % molecules/drop-s      2_ROO ==> ROH + aldehyde + O2
                    rates(4) = (0.10/D_vec(i)*k_vec(j)*N_ROO/Vol)*Vol;                      % D in nm       % molecules/drop-s      ROO + X(aq) ==> ROOH + X_dot(aq)

                    tau = 1/(rates(1) + rates(2) + rates(3) + rates(4));    % recompute Tau at this condition
                    
                    mctime = mctime - tau*log(rand);    % determine the time until the next reaction event; add to current time to get new time
                    
                    rand2 = rand;
                    %determine the fate next reaction that happens, and
                    %make the reaction happen by update N_x values
                    if(rand2 <= tau*rates(1))         % ROOH + 2_RH + 2_O2 ==> 2_ROO + ROH + H2O
                        N_ROOH = N_ROOH - 1;
                        N_ROO = N_ROO + 2;
                    elseif(rand2 <= tau*(rates(1) + rates(2)))    % ROO + RH + O2 ==> ROOH + ROO
                        N_ROO = N_ROO - 0;
                        N_ROOH = N_ROOH + 1;
                    elseif(rand2 <= tau*(rates(1) + rates(2) + rates(3)))    % 2_ROO ==> ROH + aldehyde + O2
                        N_ROO = N_ROO - 2;
                        N_ROOH = N_ROOH;
                    elseif(rand2 <= tau*(rates(1) + rates(2) + rates(3) + rates(4)))    % ROO + X(aq) ==> ROOH + X_dot(aq)
                        N_ROO = N_ROO - 1;
                        N_ROOH = N_ROOH + 1;
                    end

                end

                C_ROOH = N_ROOH/((Nav*pi/6*D_vec(i)^3)/1e24);       % compute the new concentration base on the new N_ROOH value after reaction

            end  % while loop

            % catalogue the information from this trajectory into vectors
            if(N_ROOH == 0 & mctime > 0)% & mctime <= 1e7)          % started by died
                started_but_died(i) = started_but_died(i) + 1;
            elseif(C_ROOH < 0.01 & mctime > 1e8)                    % went too long
                went_too_long(i) = went_too_long(i) + 1;
            else
                sizect = sizect + 1;  % keeps track of the number of drops that reach critical concentration
                time_fail_temp{i}(sizect,1) = mctime;
                rate_fail_temp{i}(sizect,1) = 1/mctime;
                N_ROOH_temp{i}(sizect,1) = N_ROOH;
            end
        
        end   % end else N_ROOH ~= 0 statement
        
        % This just prints out the status of the current droplet every
        % 1/10th of the simulation... so you know things are still working
        if(places(i) == 1)
            disp(['Step Number ',num2str(mc),' of ',num2str(MC_steps(i)),';  Current wall-time = ',num2str(cputime-time_in),' seconds']);            
        else
            if(rem(mc,MC_steps(i)/10) == 0)
                disp(['Step Number ',num2str(mc),' of ',num2str(MC_steps(i)),';  Current wall-time = ',num2str(cputime-time_in),' seconds']);
            end
        end
        
    end   % end iterations of N_droplets

    % Now we need to get rid of all of the NaN that we started with in our
    % solution vectors, and did not fill in with real data.  This finds the
    % largest position that is not a NaN (where the last data point lies)
    max_not_nan = max(find(isnan(N_ROOH_temp{i})==0));
    
    % generate the final vectors to be used in the histogram
    N_ROOH_final{i} = N_ROOH_temp{i}(1:max_not_nan);
    time_fail_final{i} = time_fail_temp{i}(1:max_not_nan);
    rate_fail_final{i} = rate_fail_temp{i}(1:max_not_nan);
    
    % generate histograms based on the log-spaced bins
    figure;
    hist(time_fail_final{i}(:),logspace(3,8,50));
    set(gca,'Xscale','log'); axis([1e3 1e8 0 1]); axis 'auto y';
    
    figure;
    hist(rate_fail_final{i}(:),logspace(-8,-3,50));
    set(gca,'Xscale','log'); axis([1e-8 1e-3 0 1]); axis 'auto y';
    
    % Print out some information on the stats for this diameter
    alive(i) = MC_steps(i) - started_dead(i);
    disp('  ');
    disp(['Number of steps that reached critical C_ROOH: ',num2str(length(N_ROOH_final{i}(:))),' of ',num2str(MC_steps(i)),' steps']);
    disp(['Went too long (but did not die): ',num2str(went_too_long(i)),' of ',num2str(alive(i)),' steps']);
    disp(['Number of droplets that died (but started alive): ',num2str(started_but_died(i)),' of ',num2str(alive(i))]);
    disp(['Fraction of droplets that started dead: ',num2str(started_dead(i)),' of ',num2str(MC_steps(i)),' (',num2str(started_dead(i)/MC_steps(i)*100),'%)']);
    disp('  ');
    disp('  ');
    pause(1);
end

% displat the total time that the code took to run
time_total = cputime - time_0;
disp(['Total wall-time = ',num2str(time_total/3600),' hours']);

save('workspace_whatever');


% Other functions used in the code
%========================================
function dCdt = continuum_solver(time,C,T,D,k,C_RH,C_O2)
% this function returns the differential equations used to solve the
% continuum problem.  Inputs are temperature in kelvin, D in nm, k in
% nm/sec, and concentrations in moles/L.  Output is the dX/dt values in
% moles/L-sec

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
% this function takes in the concentrations in moles/L and the droplet
% diameter in nm, and returns the number of molecules that would be
% expected in a single droplet of size D.

% diameter should be in nanometers and the concentration in moles/liter
Nav = 6.022e23;
% number of molecules in the droplet: N = C*Nav*pi/6*D^3*(1 dm^3/10^24 nm^3)
N_ROO = (C_ROO*Nav*pi/6*D^3)/1e24;
N_ROOH = (C_ROOH*Nav*pi/6*D^3)/1e24;
N_RH = (C_RH*Nav*pi/6*D^3)/1e24;
N_O2 = (C_O2*Nav*pi/6*D^3)/1e24;

return;
