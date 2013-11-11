% 10.34 - Fall 2006
% Hw Set #7 - Problem #2
% Rob Ashcraft - Oct. 20, 2006

% This function solve the reactor optimization problem in Beers' text 5.B.4.
% This implementation uses all unscaled variables, and requires very high 
% tolerances in order to force V_rxtr to vary. 

function p2_main
clear; clc;

% rate constant data at 298K and 310K for k1 --> k5
T_data = [298, 310];  % kelvin
k_T = [0.01, 0.02;  0.01, 0.02;  0.001, 0.005;  0.001, 0.005;  0.001, 0.005];  % L/mol-s

T_plot = linspace(273,335,20);
for i=1:length(k_T)
    EaR(i,1) = -log(k_T(i,1)/k_T(i,2)) / (1/T_data(1) - 1/T_data(2));  % solve for Ea/R for each reaction
    Af(i,1) = k_T(i,1)*exp(EaR(i)/T_data(1));  % solve for the A-factor using k(298K) 
    k_plot(:,i) = Af(i).*exp(-EaR(i)./T_plot);  % make a vector k(T) to plot
end

% plot the rate constants to make sure they fit the data
figure;
semilogy(T_data,k_T(1,:),'ok',T_plot,k_plot(:,1),'-',T_data,k_T(3,:),'*k',T_plot,k_plot(:,3),'--'); 
xlabel('Temperature (K)'); ylabel('Rate Constant (L/mole-s)');
legend('k_1 and k_2 data','k_1 and k_2 fit','k_3, k_4, k_5 data','k_3, k_4, k_5 fit','location','SouthEast');


% now deal with the reactor problem
V_flow = 1;  % L/s

% initial guesses for the optimization:
C_Ao_guess = 1;  % molar
C_Bo_guess = 1;  % molar
T_guess = 315;  % Kelvin
V_rxtr_guess = 5000;  % liters

var0 = [C_Ao_guess; C_Bo_guess; T_guess; V_rxtr_guess];

options = optimset('Display','iter','TolFun',1e-15,'TolX',1e-10,...
    'TolCon',1e-10,'MaxFunEval',10000);

% Define the constraint that Ca + Cb < 2 M
A = [1, 1, 0, 0];
b = 2;

% Include the given upper and lower bounds on the system varaible
lb = [0; 0; 298; 10];
ub = [2; 2; 335; 10000];

[var, fval] = fmincon(@obj_fun,var0,A,b,[],[],lb,ub,[],options,V_flow,Af,EaR);

disp(['Inlet [A] = ',num2str(var(1)),' M']);
disp(['Inlet [B] = ',num2str(var(2)),' M']);
disp(['Reactor Temperature = ',num2str(var(3)),' K']);
disp(['Reactor Volume = ',num2str(var(4)),' L']);
disp(['Outlet [C] = ',num2str(-fval),' M']);

C_Ao = var(1);
C_Bo = var(2);
T = var(3);
V_rxtr = var(4);

% Since we found out early that the V_rxtr term was causing problems, it is
% also useful to look at the cost function as a function of V_rxtr, and
% make sure our fmincon solution appears to be at the minimum.
test = logspace(1,4,50);
for i=1:length(test)
cost_i(i) = obj_fun([var(1:3);(test(i))],V_flow,Af,EaR);
end

figure;
semilogx(test,cost_i,'-',V_rxtr,fval,'o')
xlabel('Reactor Volume (L)'); ylabel('Cost Function (-[C]_o_u_t  M)');
legend('Cost Function','fmincon Solution');
return;


% other functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Define the function called by fmincon with the cost function
% we use fsolve in this case
function cost = obj_fun(var,V_flow,Af,EaR)

    C_Ao = var(1);
    C_Bo = var(2);
    T = var(3);
    V_rxtr = var(4);

    C_guess = [1; 1; 0; 0; 0; 0; 0; 0];
    options = optimset('Display','off','TolX',1e-14,'TolFun',1e-16);
    
    % we need to find the steady state values of outlet concentrations
    C_all = fsolve(@rxtr_dCdt_fsolve,C_guess,options,C_Ao,C_Bo,T,V_rxtr,V_flow,Af,EaR);
    
    cost = -C_all(3);

return;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function dAlldt = rxtr_dCdt_fsolve(C_all,C_Ao,C_Bo,T,V_rxtr,V_flow,Af,EaR)
%  all of the C variable are concentrations in moles/L

    tau = V_flow/V_rxtr;

    A = C_all(1);
    B = C_all(2);
    C = C_all(3);
    D = C_all(4);
    S1 = C_all(5);
    S2 = C_all(6);
    S3 = C_all(7);
    S4 = C_all(8);

    k = Af.*exp(-EaR./T);

    dAdt = -k(1)*A*B - k(3)*A*D - k(4)*A*B + tau*(C_Ao - A);
    dBdt = -k(1)*A*B - k(2)*B*C - k(4)*A*B - k(5)*B*C + tau*(C_Bo - B);
    dCdt = k(1)*A*B - k(2)*B*C - k(5)*B*C - tau*C;
    dDdt = k(1)*A*B + k(2)*B*C - k(3)*A*D - tau*D;
    dS1dt = k(2)*B*C - tau*S1;
    dS2dt = k(3)*A*D - tau*S2;
    dS3dt = k(4)*A*B - tau*S3;
    dS4dt = k(5)*B*C - tau*S4;

    dAlldt = [dAdt; dBdt; dCdt; dDdt; dS1dt; dS2dt; dS3dt; dS4dt];

return;








