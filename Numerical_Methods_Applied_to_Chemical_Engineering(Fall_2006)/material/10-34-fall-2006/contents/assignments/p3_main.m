% 10.34 - Fall 2006
% Hw Set #7 - Problem #3
% Rob Ashcraft - Oct. 20, 2006

%equilibrium solving
function p3_main
clear; clc;


moles_spec_in = [2; 3; .5; 0; 0; 1; 0];

options = optimset('Display','iter','TolFun',1e-8,'TolX',1e-14,'TolCon',1e-14);

% Define inequality constraints (A*x <= b)
A = eye(7)*(-1);
b = ones(7,1)*1e-14;

% define the C, H, and O conservation (equality constraints)
Aeq = [1    0   1   1   0   0   0;
       4    2   0   0   1   2   2;
       0    1   1   2   2   0   2];

moles_atoms_in = Aeq*moles_spec_in;
   
C_in = moles_atoms_in(1);  %moles
H_in = moles_atoms_in(2);
O_in = moles_atoms_in(3);

beq = [C_in;  H_in;  O_in];

lb = ones(7,1)*1e-14;
ub = ones(7,1)*20;

n_var0 = [    0.0459
    1.9934
    1.2958
    0.6583
    0.0000
    5.7176
    0.1042];

[n_var, fval] = fmincon(@obj_fun,n_var0,A,b,Aeq,beq,lb,ub,[],options);

n_total = sum(n_var);

n_ch4 = n_var(1);
n_h2o = n_var(2);
n_co = n_var(3);
n_co2 = n_var(4);
n_ho2 = n_var(5);
n_h2 = n_var(6);
n_hooh = n_var(7);

y_ch4 = n_ch4/n_total;
y_h2o = n_h2o/n_total;
y_co = n_co/n_total;
y_co2 = n_co2/n_total;
y_ho2 = n_ho2/n_total;
y_h2 = n_h2/n_total;
y_hooh = n_hooh/n_total;

disp('  ');
disp('  ');
disp(['Total moles initially:  ',num2str(sum(moles_spec_in))]);
disp(['Initial Volume (L):  ',num2str(sum(moles_spec_in)*0.08206*1000/1)]);
disp('  ');
disp(['Total moles at equilibrium:  ',num2str(n_total)]);
disp(['Final Volume (L):  ',num2str(n_total*0.08206*1000/1)]);
disp('  ');
disp(['CH4:   mole fraction: ',num2str(y_ch4,'%1.5f'),',    number of moles: ',num2str(n_ch4,'%1.5f')]);
disp(['H2O:   mole fraction: ',num2str(y_h2o,'%1.5f'),',    number of moles: ',num2str(n_h2o,'%1.5f')]);
disp(['CO:    mole fraction: ',num2str(y_co,'%1.5f'),',    number of moles: ',num2str(n_co,'%1.5f')]);
disp(['CO2:   mole fraction: ',num2str(y_co2,'%1.5f'),',    number of moles: ',num2str(n_co2,'%1.5f')]);
disp(['H2:    mole fraction: ',num2str(y_h2,'%1.5f'),',    number of moles: ',num2str(n_h2,'%1.5f')]);
disp(['HOOH:  mole fraction: ',num2str(y_hooh,'%1.5f'),',    number of moles: ',num2str(n_hooh,'%1.5f')]);
disp(['HO2:   mole fraction: ',num2str(y_ho2,'%1.2e'),',  number of moles: ',num2str(n_ho2,'%1.2e')]);


function cost = obj_fun(n_var)

T = 1000;  %kelvin
R = 8.314;  % J/mol-K

n_total = sum(n_var);

n_ch4 = n_var(1);
n_h2o = n_var(2);
n_co = n_var(3);
n_co2 = n_var(4);
n_ho2 = n_var(5);
n_h2 = n_var(6);
n_hooh = n_var(7);

%Gibb free energies at 1000K in kJ/mole
G_ch4 = 19720;
G_h2o = -192420;
G_co = -200240;
G_co2 = -395790;
G_ho2 = -227000;
G_h2 = 0;
G_hooh = -369060;


% minimize the chemical potential of the system:

cost =  n_ch4*(G_ch4 + R*T*log(n_ch4/n_total)) +...
        n_h2o*(G_h2o + R*T*log(n_h2o/n_total)) +...
        n_co*(G_co + R*T*log(n_co/n_total)) +...
        n_co2*(G_co2 + R*T*log(n_co2/n_total)) +...
        n_ho2*(G_ho2 + R*T*log(n_ho2/n_total)) +...
        n_h2*(G_h2 + R*T*log(n_h2/n_total)) +...
        n_hooh*(G_hooh + R*T*log(n_hooh/n_total));

% cost =  n_ch4*(G_ch4) +...
%         n_h2o*(G_h2o) +...
%         n_co*(G_co) +...
%         n_co2*(G_co2) +...
%         n_ho2*(G_ho2) +...
%         n_h2*(G_h2);

return;


