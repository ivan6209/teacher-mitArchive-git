% 10.34 - Fall 2006
% Hw Set #8 - Problem #2
% Rob Ashcraft - Oct. 25, 2006


% reaction in a spherical catalyst particle

function p2_main_unscaled

clear;

global Ds_gel S_bulk rate_0 Km

Nr_vec = [101];
    
Sh = 10;

R_vec = [0.0005, 0.001, 0.005];

%R_vec = logspace(log10(2e-4), log10(0.02), 21)';
%R_vec = linspace(2e-4, 0.02, 21)';


S_bulk = 1000;  % moles/m^3

rhoE = 0.01*1e6;  % mgE/m^3 gel
Ds_gel = 1e-10;  % m^2/s
Ds_liq = 7e-10;  % m^2/s

Vm = 200/60/1e6;  % mole/s-mgE
Km = 200;  % mole/m^3

rate_0 = Vm*rhoE;  % mole/m^3-s

S_vec = zeros(max(Nr_vec),length(R_vec));

for ct_Nr = 1:length(Nr_vec)
    for ct = 1:length(R_vec)

        Nr = Nr_vec(ct_Nr);

        R = R_vec(ct);

        k_mass(ct) = Sh*Ds_liq/(2*R);    % m/s

        dr(ct) = R/(Nr-1);
        for i=1:Nr 
            r(i,ct) = 0 + (i-1)*dr(ct);
        end

        options=optimset('display','off','tolfun',1e-12,'tolx',1e-12,'MaxFunEvals',100000,'MaxIter',1000);
        
        if(ct == 1)
            var_guess = linspace(0,1000,Nr)';
        else
            var_guess = S_guess(:,ct-1);
        end
        S_guess(1:Nr,ct) = fsolve(@fin_diff_eqn_const,var_guess,options,Nr,dr(ct),k_mass(ct));
        
        options=optimset('display','iter','tolfun',1e-14,'tolx',1e-14,'MaxFunEvals',100000,'MaxIter',1000);
        var_0 = S_guess(:,ct);
        S_vec(1:Nr,ct) = fsolve(@fin_diff_eqn,var_0,options,Nr,dr(ct),k_mass(ct));

        resid(:,i)=fin_diff_eqn(S_vec(:,ct),Nr,dr(ct),k_mass(ct));
        resid(1)
        resid(end)
        %Ds_gel*(S_vec(Nr,ct) - S_vec(Nr-1,ct))/dr(ct) - (k_mass(ct)*(S_bulk - S_vec(Nr,ct)))
    end

    max(S_vec);

    for i=1:length(R_vec)
        cons_rate(i,ct_Nr) = k_mass(i)*(S_bulk - S_vec(end,i))*4*3.1415*R_vec(i)^2;    % moles/sec
        cons_rate_in(i,ct_Nr) = Ds_gel*(S_vec(end,i) - S_vec(end-1,i))/dr(i)*4*3.1415*R_vec(i)^2;    % moles/sec
        mass_E(i) = 4/3*3.1415*R_vec(i)^3 * rhoE;  % mgE per bead
        mole_per_kgE(i,ct_Nr) = cons_rate(i,ct_Nr)/mass_E(i)*1e6;     % moles/mgE-sec
        mole_per_kgE_in(i,ct_Nr) = cons_rate_in(i,ct_Nr)/mass_E(i)*1e6;     % moles/mgE-sec

        %disp(['Consumption Rate (Outer) for R = ',num2str(R_vec(i)),' m:  ',num2str(mole_per_kgE(i,ct_Nr)),' moles S per kg E']);
        disp('  ');
        disp(['Results for R = ',num2str(R_vec(i)),' meters:']);
        disp(['[S] at the bead surface:  ',num2str(S_vec(end,i)),' moles/m^3']);
        disp(['Consumption Rate:  ',num2str(cons_rate_in(i,ct_Nr)),' moles/sec']);
        disp(['Consumption Rate per kg of Enzyme:  ',num2str(mole_per_kgE_in(i,ct_Nr)),' moles/sec S per kg E']);

        r_scaled(:,i) = r(:,i)/R_vec(i);
    end
end
k_mass

figure; plot(R_vec,mole_per_kgE(:,end),'o');

figure;
plot(r(:,1)/R_vec(1),S_vec(:,1),'-',r(:,2)/R_vec(2),S_vec(:,2),'-.',r(:,3)/R_vec(3),S_vec(:,3),'--');
xlabel('r/R  (scaled radius)'); ylabel('Concentration  (mole/m^3)');
legend('R = 0.5 mm','R = 1.0 mm','R = 5.0 mm');

% figure;
% plot(r_scaled,S_vec)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function resid = fin_diff_eqn(var,Nr,dr,k_mass)

global Ds_gel S_bulk rate_0 Km

S = var;

for i=1:Nr
    
    r(i) = 0 + (i-1)*dr;
    
    if(i == 1)
        resid(i) = (S(i) - 4/3*S(i+1) + 1/3*S(i+2))*1e9;
        
    elseif(i == Nr)  % BC @ r=R: Dgel*dS/dr = k_mass*(S_bulk - S(r=R))
        %resid(i) = (S(i) - S(i-1))/dr - (k_mass/Ds_gel*(S_bulk - S(i)));
        resid(i) = (Ds_gel*(S(i) - S(i-1))/dr - (k_mass*(S_bulk - S(i))))*1e9;
    else
        resid(i) = r(i)/dr^2*(S(i+1) - 2*S(i) + S(i-1))...
            + 2/(2*dr)*(S(i+1) - S(i-1))...
            - r(i)*rate_0/Ds_gel*S(i)/(Km+S(i));
    end
end

return;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function resid = fin_diff_eqn_const(var,Nr,dr,k_mass)

global Ds_gel S_bulk rate_0 Km

S = var;

for i=1:Nr
    
    r(i) = 0 + (i-1)*dr;
    
    if(i == 1)
        resid(i) = S(i) - 4/3*S(i+1) + 1/3*S(i+2);
        
    elseif(i == Nr)  % BC @ r=R: Dgel*dS/dr = k_mass*(S_bulk - S(r=R))
        %resid(i) = (S(i) - S(i-1))/dr - (k_mass/Ds_gel*(S_bulk - S(i)));
        resid(i) = (S(i) - 1000);
    else
        resid(i) = r(i)/dr^2*(S(i+1) - 2*S(i) + S(i-1))...
            + 2/(2*dr)*(S(i+1) - S(i-1))...
            - r(i)*rate_0/Ds_gel*S(i)/(Km+S(i));
    end
end

return;
    
    
    
    
    