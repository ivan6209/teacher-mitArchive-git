% 10.34 - Fall 2006
% Hw Set #6
% Rob Ashcraft - Oct. 12, 2006

% Chemostat problem with unscaled variables.  ODE solvers are used to
% determine the transient and steady-state behavior of a chemostat

function pset6p1_main

clear; clc;

% define the parameter values for the seed reactor
params = param_set;

V_flow_quiz1 = 2.3/60;  % liters/sec
Vrxtr_quiz1 = 150;   % liters
C_nut_in_quiz1 = 0.2;  % in Molar

%guess an initial condition from which to integrate to SS
Ncells_0 = 1e5; 
C_nut_0 = 0.05; 
C_P_0 = 0.05;

var_0 = [Ncells_0, C_nut_0, C_P_0];

options = odeset('RelTol',1e-10,'AbsTol',1e-12);
%options = [];

% Integrate from 0 --> 100 hours, which should reach SS, but will also be
% checked by visually inspecting a graph.
tspan = [0 100*3600];  %in seconds

% Solve the ODE for the seed reactor with the given parameters
[time, var] = ode15s(@chemostat,tspan,var_0,options,C_nut_in_quiz1,params,V_flow_quiz1,Vrxtr_quiz1);

% report the steady-state conditions by taking the conditions as the final
% time point in the integration
Ncells_SS = var(end,1);
C_cells_SS = Ncells_SS/Vrxtr_quiz1;
Nut_SS = var(end,2);
P_SS = var(end,3);

disp('  ');
disp('Steady-State Solution to the 150 L CSTR');
disp('  ');
disp(['Number of Cells in Reactor = ',num2str(var(end,1),'%8.6e')]);
disp(['Concentration of Cells in Reactor = ',num2str(C_cells_SS,'%8.6e')]);
disp(['Concentration of Nutrients (M) = ',num2str(var(end,2))]);
disp(['Concentration of Product (M) = ',num2str(var(end,3))]);
disp('  ');
disp(['Production Rate of Product (mole/hr) = ',num2str(var(end,3)*V_flow_quiz1*3600)]);
%resid_final = chemostat(var,C_nut_in,params)


% move on to the 230L reactor that will be seeded with output from the 150L
% reactor that we just solved.

% Define the times at which the flow will begin.  1e-6 was used as a
% surrogate for zero so the method below will work for all cases.
t_nut_vec = [1e-6, 2, 8];  % in hours

% define the parameters used in the 230L reactor
V_flow_p1 = 2.3/60;  % liters/sec
Vrxtr_p1 = 230;   % liters

C_nut_in_p1 = 0.2;  % in Molar

%initial conditions in the 230 L reactor.  Generally, concentrations are calculated
%as the number of moles of X in the one liter aliquot, then added to the
%number of moles in the 229L of nutrient solution, then divided by 230L.
Ncells_0 = Ncells_SS/150;  % Ncells in one liter of seed reactor mixture
C_nut_0 = (C_nut_in_p1*229 + Nut_SS*1)/230; 
C_P_0 = P_SS/230;

var_0 = [Ncells_0, C_nut_0, C_P_0];

disp('  ');
disp('  ');
disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
disp('Using the Explicit Solver (ode23s)');
disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
disp('  ');

%iterate over the t_nut vector to do each case
for i=1:length(t_nut_vec)
        t_nut = t_nut_vec(i);  %pick the appropriate t_nut value

        % for the first leg, we will integrate for zero to t_nut, and set
        % the nutrient flow rate to zero over this time period.  
        tspan1 = [0 t_nut*3600];
        V_flow_p1_0 = 0;
    
        time_in = cputime;
        [time2, var2] = ode23s(@chemostat,tspan1,var_0,options,C_nut_in_quiz1,params,V_flow_p1_0,Vrxtr_p1);

        % next, we integrate from t_nut to t_final and set the flow rate to
        % the value specified in the problem.  The initial condition for
        % this ODE system is the final values return by the previous step
        tspan1 = [t_nut*3600 100*3600];
        var_0_1 = [var2(end,1), var2(end,2), var2(end,3)];
        V_flow_p1_1 = V_flow_p1;

        [time3, var3] = ode23s(@chemostat,tspan1,var_0_1,options,C_nut_in_quiz1,params,V_flow_p1_1,Vrxtr_p1);
        
        time_int = cputime - time_in;
        
        % combine the 1st and 2nd step into single vectors
        time_all = [time2; time3];
        var_all = [var2; var3];
        
        % The determine the number of steps taken in each 100-second
        % period, we need to divide the space up into equal bins of this
        % length.  This is done by using linspace to split T into T/100+1
        % points (between which are T/100 bins).
        t_histo = linspace(0,25*3600,25*3600/100+1);
        for k = 1:length(t_histo)
            if(k == 1)
                n_steps_0 = 0; % there are no steps before time = 0
            else
                % n_step_0 is the number steps taken before the current
                % time point.  
                n_steps_0 = n_steps_1(k-1);
            end
            % this finds the total number of steps taken before the current
            % time point
            n_steps_1(k) = length(find(time_all < t_histo(k)));
            
            % the number of steps in this time interval is found by
            % subtracting the number of steps before the previous time
            % point for the number of steps before the current time point
            n_steps(k) = n_steps_1(k) - n_steps_0;
        end
              
        % this plots the Ncell and n_steps on the same plot with two axes.
        % It is a bit complicated, so I will not explain it here
        figure;
        [AX,H1,H2] = plotyy(time_all/3600,var_all(:,1),t_histo/3600,n_steps,'loglog','semilogx');
        axis([1e-2 25 0 1]); axis 'auto y';
        set(H1,'LineStyle','-');
        set(H2,'Marker','o','LineStyle','none');
        set(AX(2),'xlim',[1e-2 25]);
        set(AX(1),'yTickMode','auto')
        set(AX(2),'yTickMode','auto')
        xlabel('Time  [hr]');
        set(get(AX(1),'YLabel'),'String','Number of Cells in CSTR');
        set(get(AX(2),'YLabel'),'String','Number of Time Steps in Bin');
        title(['Stiff ODE Solver (ode23s) with t_n_u_t = ',num2str(t_nut,'%2.0f'),' hrs']);


        % find the steady state values of the 230L reactor
        Ncells_SS_p1 = var_all(end,1);
        C_cells_SS_p1 = Ncells_SS_p1/Vrxtr_p1;
        Nut_SS_p1 = var_all(end,2);
        P_SS_p1 = var_all(end,3);
        
        % convert the Ncells vector to a percent of the steady state value.
        percent_SS = var_all(:,1)/Ncells_SS_p1;
        
        % find the vector indices where the Ncells is within 1% of the
        % long-time SS value
        [loc_99] = find(percent_SS < 0.99 | percent_SS > 1.01);
        
        % find the final time point that lies outside the 1% range, then take
        % the next time point as the time to reach 1% of SS
        [time_99] = time_all(max(loc_99)+1);


        disp(['For Time(flow start) = ',num2str(t_nut,'%2.2f'),' hours:']);
        disp('  ');
        disp(['Number of Cells in Reactor = ',num2str(var_all(end,1),'%8.6e')]);
        disp(['Concentration of Cells in Reactor = ',num2str(C_cells_SS_p1,'%8.6e')]);
        disp(['Concentration of Nutrients (M) = ',num2str(var_all(end,2))]);
        disp(['Concentration of Product (M) = ',num2str(var_all(end,3))]);
        disp('  ');
        disp(['Production Rate of Product (mole/hr) = ',num2str(var_all(end,3)*V_flow_quiz1*3600)]);
        disp('  ');
        disp(['Time to 99% of Steady-State (sec) = ',num2str(time_99)]);
        disp(['Time to Solve ODE System (sec) = ',num2str(time_int)]);
        disp(['Number of Integrator Steps Taken = ',num2str(length(time_all))]);
        disp('  ');
        disp('  ');
end

disp('  ');
disp('  ');
disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
disp('Using the Explicit Solver (ode45)');
disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
disp('  ');

% this is basically identical to the above procedure 
for i=1:length(t_nut_vec)
        t_nut = t_nut_vec(i);

        tspan1 = [0 t_nut*3600];
        V_flow_p1_0 = 0;
    
        time_in = cputime;
        [time2, var2] = ode45(@chemostat,tspan1,var_0,options,C_nut_in_quiz1,params,V_flow_p1_0,Vrxtr_p1);

        tspan1 = [t_nut*3600 100*3600];
        var_0_1 = [var2(end,1), var2(end,2), var2(end,3)];
        V_flow_p1_1 = V_flow_p1;

        [time3, var3] = ode45(@chemostat,tspan1,var_0_1,options,C_nut_in_quiz1,params,V_flow_p1_1,Vrxtr_p1);
        
        time_int = cputime - time_in;
        
        time_all = [time2; time3];
        var_all = [var2; var3];
        

        t_histo = linspace(0,25*3600,25*3600/100+1);
        for k = 1:length(t_histo)
            if(k == 1)
                n_steps_0 = 0;
            else
                n_steps_0 = n_steps_1(k-1);
            end
            n_steps_1(k) = length(find(time_all < t_histo(k)));
            
            n_steps(k) = n_steps_1(k) - n_steps_0;
        end
              
        figure;
        [AX,H1,H2] = plotyy(time_all/3600,var_all(:,1),t_histo/3600,n_steps,'loglog','semilogx');
        axis([1e-2 25 0 1]); axis 'auto y';
        set(H1,'LineStyle','-');
        set(H2,'Marker','o','LineStyle','none');
        set(AX(2),'xlim',[1e-2 25]);
        set(AX(1),'yTickMode','auto')
        set(AX(2),'yTickMode','auto')
        xlabel('Time  [hr]');
        set(get(AX(1),'YLabel'),'String','Number of Cells in CSTR');
        set(get(AX(2),'YLabel'),'String','Number of Time Steps in Bin');
        title(['Explicit ODE Solver (ode45) with t_n_u_t = ',num2str(t_nut,'%2.0f'),' hrs']);


        Ncells_SS_p1 = var_all(end,1);
        C_cells_SS_p1 = Ncells_SS_p1/Vrxtr_p1;
        Nut_SS_p1 = var_all(end,2);
        P_SS_p1 = var_all(end,3);
        
        percent_SS = var_all(:,1)/Ncells_SS_p1;
        
        [loc_99] = find(percent_SS < 0.99 | percent_SS > 1.01);;
        
        [time_99] = time_all(max(loc_99)+1);

        disp(['For Time(flow start) = ',num2str(t_nut,'%2.2f'),' hours:']);
        disp('  ');
        disp(['Number of Cells in Reactor = ',num2str(var_all(end,1),'%8.6e')]);
        disp(['Concentration of Cells in Reactor = ',num2str(C_cells_SS_p1,'%8.6e')]);
        disp(['Concentration of Nutrients (M) = ',num2str(var_all(end,2))]);
        disp(['Concentration of Product (M) = ',num2str(var_all(end,3))]);
        disp('  ');
        disp(['Production Rate of Product (mole/hr) = ',num2str(var_all(end,3)*V_flow_quiz1*3600)]);
        disp('  ');
        disp(['Time to 99% of Steady-State (sec) = ',num2str(time_99)]);
        disp(['Time to Solve ODE System (sec) = ',num2str(time_int)]);
        disp(['Number of Integrator Steps Taken = ',num2str(length(time_all))]);
        disp('  ');
        disp('  ');
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this function defines the ODE's to be solved: dX/dt = F(X)
function dXdt = chemostat(time,var,C_nut_in,params,V_flow,Vrxtr)

Ncells = var(1);  % number of cells
C_nut = var(2);  % concentration of nutrients
C_P = var(3);  % concentration of products

CMrate = Cell_Multiplication(Ncells,C_nut,C_P,params);
NCrate = Nutrient_Consumption(Ncells,C_nut,C_P,params);
Prate = P_production(Ncells,C_nut,C_P,params);

dNcell_dt = CMrate - V_flow*Ncells/Vrxtr;

dNut_dt = 1/Vrxtr*((C_nut_in - C_nut)*V_flow - NCrate);

dP_dt = 1/Vrxtr*(Prate - V_flow*C_P);

dXdt = [dNcell_dt; dNut_dt; dP_dt];

return;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function CMrate = Cell_Multiplication(Ncells,Nutrients,P,params)
% computes the Cell Multiplication rate (cells/s) in the CSTR
% inputs:
%   Ncells       number of cells in the CSTR
%   Nutrients    concentration of Nutrients in the CSTR (moles/liter)
%   P		     concentration of Product in CSTR, [=] moles/liter
%   params       values of [k1,k2,k3,c1,c2,d] as listed in problem statement.
k1 = params(1); c1=params(4); d=params(6);
CMrate = k1.*Ncells.*Nutrients./((1+c1.*Nutrients).*(1+d.*P));

return;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function NCrate = Nutrient_Consumption(Ncells,Nutrients,P,params)
% computes the nutrient consumption rate in the CSTR (moles/s)
% inputs:
%   Ncells    	number of cells in the CSTR
%   Nutrients     concentration of Nutrients in the CSTR (moles/liter)
%   P		      concentration of Product in CSTR, [=] moles/liter
%   params        values of [k1,k2,k3,c1,c2,d] as listed in problem statement.
k2 = params(2);    c2 = params(5);
NCrate = k2*Ncells*(Nutrients - 1e-6) + c2*Cell_Multiplication(Ncells,Nutrients,P,params);

return;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Prate = P_production(Ncells,Nutrients,P,params)
% computes the product production rate in the CSTR (moles/s)
% inputs:
%   Ncells    	number of cells in the CSTR
%   Nutrients     concentration of Nutrients in the CSTR (moles/liter)
%   P		      concentration of Product in CSTR, [=] moles/liter
%   params        values of [k1,k2,k3,c1,c2,d] as listed in problem statement.
k3 = params(3); d=params(6); c1=params(4);
Prate = k3.*Ncells.*exp(-d.*P).*((Nutrients-0.01).^2)./(1+c1.*Nutrients);

return;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function params = param_set
% sets params as in the problem statement
% [k1  k2  k3  c1  c2  d]
params = [5e-3 1e-9 1e-8 0.1 1e-7 0.01];

return;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



