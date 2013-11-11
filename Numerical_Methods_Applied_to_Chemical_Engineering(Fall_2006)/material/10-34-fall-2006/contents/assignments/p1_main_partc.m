% 10.34 - Fall 2006
% HW Set #11 - Kinetic Monte Carlo (Gillespie's Algorithm)
% Rob Ashcraft
% 12/10/2006

% This will generate the data necessary to do part 3.  It calculates the
% rate of failure for D = 250 nm for various k-values to determine the
% dependence of rate of failure on k.  

% This is very similar to "p1_mian.m".  see that code for extensive
% commenting.  


function p1_main_partc

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

disp('Initial number of molecules of: ROO, ROOH, RH, and O2 in droplet of size D');
for i=1:length(D_vec)
    [N_ROO_0,N_ROOH_0,N_RH_0,N_O2_0] = calc_N(C_ROO_0,C_ROOH_0,C_RH_0,C_O2_0,D_vec(i));
    disp(['Droplet size (nm): ',num2str(D_vec(i)),' -- ROO = ',num2str(N_ROO_0),...
        ',  ROOH = ',num2str(N_ROOH_0),',  RH = ',num2str(N_RH_0),',  O2 = ',num2str(N_O2_0)]);
    legend_D{i,1} = ['D = ',num2str(D_vec(i)),' nm'];
end
disp('  ');


% Now work on the Kinetic Monte Carlo part of the problem:
t_per_D = 1800;  % wall time you want to spend per droplet size

% Total sim time at a function of number of steps(N):  Time = m*N
% these values will different on a different computer
m =  [1.85e-5;
      8.88e-5;
      0.0026;
      0.113;
      0.898;
      7.188;
      113.1];

for i = 1:length(D_vec)

    MC_steps_temp(i) = t_per_D/m(i);
    
    places(i) = length(num2str(round(MC_steps_temp(i))));  % number of place left of decimal
    if(places(i) > 2)
        MC_steps(i) = ceil(MC_steps_temp(i)/(10^(places(i)-2))) * 10^(places(i)-2);
    elseif(places(i) == 2)
        MC_steps(i) = ceil(MC_steps_temp(i)/10) * 10;
    else
        MC_steps(i) = ceil(MC_steps_temp(i));
    end
end

k_vec_partC = logspace(0,3,13);

for j=1:length(k_vec_partC);    % for k = 10
for i = 4:4%length(D_vec)
    time_in = cputime;
    
    disp(['Now running MC simulation for D = ',num2str(D_vec(i)),' nm']);
    started_dead(j) = 0;
    started_but_died(j) = 0;
    went_too_long(j) = 0;

    tc = 1;
    [N_ROO,N_ROOH,N_RH_0,N_O2_0] = calc_N(C_ROO_0,C_ROOH_0,C_RH_0,C_O2_0,D_vec(i));

    % defined vector sizes to make the code run faster
    if(N_ROOH > 1)
        N_ROOH_temp{j} = zeros(MC_steps(i),1);
        time_fail_temp{j} = zeros(MC_steps(i),1);
        rate_fail_temp{j} = zeros(MC_steps(i),1);
    else        
        N_ROOH_temp{j} = zeros(MC_steps(i)*N_ROOH*1.25,1)*NaN;
        time_fail_temp{j} = zeros(MC_steps(i)*N_ROOH*1.25,1)*NaN;
        rate_fail_temp{j} = zeros(MC_steps(i)*N_ROOH*1.25,1)*NaN;
    end
    
    Vol = pi/6*D_vec(i)^3;  % volume in nm^3
    
    sizect = 0;
    for mc = 1:MC_steps(i)

        [N_ROO,N_ROOH,N_RH_0,N_O2_0] = calc_N(C_ROO_0,C_ROOH_0,C_RH_0,C_O2_0,D_vec(i));
        
        % since the N_0's calculated from the concentrations will be non-integer,
        % we need to round them to the nearest integer based on a probability.
        % This is accomplished with the following lines:
        N_ROO = round(N_ROO + (rand-.5));
        N_ROOH = round(N_ROOH + (rand-.5));
        N_RH_0 = round(N_RH_0 + (rand-.5));
        N_O2_0 = round(N_O2_0 + (rand-.5));
        
        if(N_ROOH == 0)
            %rates = [0;0;0;0];   tau = inf;
            started_dead(j) = started_dead(j)+1;
            mctime = NaN;
            %N_ROOH_final{i}(mc,1) = NaN;
            %time_fail_final{i}(mc,1) = mctime;
            
        else
            
            rates(1) = (1e15*exp(-15000/Temp)*N_ROOH/Vol)*Vol;                           % molecules/nm^3-s      ROOH + 2_RH + 2_O2 ==> 2_ROO + ROH + H2O
            rates(2) = (1e9*(1e24/6.022e23)*exp(-6000/Temp)*N_ROO/Vol*N_RH_0/Vol)*Vol;     % molecules/nm^3-s      ROO + RH + O2 ==> ROOH + ROO
            rates(3) = (1e6*(1e24/6.022e23)*(N_ROO/Vol)*((N_ROO-1)/Vol))*Vol;                       % molecules/nm^3-s      2_ROO ==> ROH + aldehyde + O2
            rates(4) = (0.10/D_vec(i)*k_vec_partC(j)*N_ROO/Vol)*Vol;                      % D in nm       % molecules/nm^3-s      ROO + X(aq) ==> ROOH + X_dot(aq)

            tau = 1/(rates(1) + rates(2) + rates(3) + rates(4));
            
            mctime = 0;
            
            C_ROOH = C_ROOH_0;
            dead = 0;
            while(C_ROOH <= C_ROOH_cutoff  &  mctime <= 1e8  &  dead ~= 1  &  tau < inf)
                
                
                if(N_ROO + N_ROOH == 0)
                    dead = 1;
                    N_ROOH = N_ROOH;
                    N_ROO = N_ROO;
                elseif(N_ROO + N_ROOH ~= 0)            

                    rates(1) = (1e15*exp(-15000/Temp)*N_ROOH/Vol)*Vol;                           % molecules/nm^3-s      ROOH + 2_RH + 2_O2 ==> 2_ROO + ROH + H2O
                    rates(2) = (1e9*(1e24/6.022e23)*exp(-6000/Temp)*N_ROO/Vol*N_RH_0/Vol)*Vol;     % molecules/nm^3-s      ROO + RH + O2 ==> ROOH + ROO
                    rates(3) = (1e6*(1e24/6.022e23)*(N_ROO/Vol)*((N_ROO-1)/Vol))*Vol;                       % molecules/nm^3-s      2_ROO ==> ROH + aldehyde + O2
                    rates(4) = (0.10/D_vec(i)*k_vec_partC(j)*N_ROO/Vol)*Vol;                      % D in nm       % molecules/nm^3-s      ROO + X(aq) ==> ROOH + X_dot(aq)

                    tau = 1/(rates(1) + rates(2) + rates(3) + rates(4));
                    
                    mctime = mctime - tau*log(rand);
                    
                    rand2 = rand;
                    %determine the fate next reaction that happens
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

                    %[rates,tau] = rate_calc_N(N_ROO,N_ROOH,N_RH_0,D_vec(i),k_vec(j),Temp);
                end

                C_ROOH = N_ROOH/((Nav*pi/6*D_vec(i)^3)/1e24);

            end  % while loop

            if(N_ROOH == 0 & mctime > 0)% & mctime <= 1e7)  % started by died
                %time_fail_final{i}(sizect,1) = NaN;
                started_but_died(j) = started_but_died(j) + 1;
            elseif(C_ROOH < 0.01 & mctime > 1e7)        % went too long
                %time_fail_final{i}(sizect,1) = 1e8;
                went_too_long(j) = went_too_long(j) + 1;
            else
                sizect = sizect + 1;
                time_fail_temp{j}(sizect,1) = mctime;
                rate_fail_temp{j}(sizect,1) = 1/mctime;
                N_ROOH_temp{j}(sizect,1) = N_ROOH;
            end

            %N_ROOH_final{i}(mc,1) = N_ROOH;
        
        end   % end else N_ROOH ~= 0 statement
        
        if(places(i) == 1)
            disp(['Step Number ',num2str(mc),' of ',num2str(MC_steps(i)),';  Current wall-time = ',num2str(cputime-time_in),' seconds']);            
        else
            if(rem(mc,MC_steps(i)/10) == 0)
                disp(['Step Number ',num2str(mc),' of ',num2str(MC_steps(i)),';  Current wall-time = ',num2str(cputime-time_in),' seconds']);
            end
        end
        
    end   % end iterations of N_droplets

    max_not_nan = max(find(isnan(N_ROOH_temp{j})==0));
    
    N_ROOH_final{j} = N_ROOH_temp{j}(1:max_not_nan);
    time_fail_final_250{j} = time_fail_temp{j}(1:max_not_nan);
    rate_fail_final_250{j} = rate_fail_temp{j}(1:max_not_nan);
    
    avg_time(j) = exp(mean(log(time_fail_final_250{j})));
    
    
    %Num_died(i) = length(find(N_ROOH_final{i}(:) == 0));
    alive(j) = MC_steps(i) - started_dead(j);
    disp('  ');
    disp(['Number of steps that reached critical C_ROOH: ',num2str(length(N_ROOH_final{j}(:))),' of ',num2str(MC_steps(i)),' steps']);
    disp(['Went too long (but did not die): ',num2str(went_too_long(j)),' of ',num2str(alive(j)),' steps']);
    disp(['Number of droplets that died (but started alive): ',num2str(started_but_died(j)),' of ',num2str(alive(j))]);
    disp(['Fraction of droplets that started dead: ',num2str(started_dead(j)),' of ',num2str(MC_steps(i)),' (',num2str(started_dead(j)/MC_steps(i)*100),'%)']);
    disp('  ');
    disp('  ');
    pause(1);
end
end % loop over j (k values)

plot(k_vec_partC,avg_time,'o');

time_total = cputime - time_0;
disp(['Total wall-time = ',num2str(time_total/3600),' hours']);

save('workspace_whatever_part3');

%========================================
function [rates,tau] = rate_calc_N(N_ROO,N_ROOH,N_RH,D,k,T)
% rates are returned in molecules/nm^3-sec

Vol = pi/6*D^3;

rates(1) = (1e15*exp(-15000/T)*N_ROOH/Vol)*Vol;                           % molecules/nm^3-s      ROOH + 2_RH + 2_O2 ==> 2_ROO + ROH + H2O
rates(2) = (1e9*(1e24/6.022e23)*exp(-6000/T)*N_ROO/Vol*N_RH/Vol)*Vol;     % molecules/nm^3-s      ROO + RH + O2 ==> ROOH + ROO
rates(3) = (1e6*(1e24/6.022e23)*(N_ROO/Vol)*((N_ROO-1)/Vol))*Vol;                       % molecules/nm^3-s      2_ROO ==> ROH + aldehyde + O2
rates(4) = (0.10/D*k*N_ROO/Vol)*Vol;                      % D in nm       % molecules/nm^3-s      ROO + X(aq) ==> ROOH + X_dot(aq)
% 
% if(N_ROO < 2)
%     rates(3) = 0;
% end

tau = 1/sum(rates);

return;

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
