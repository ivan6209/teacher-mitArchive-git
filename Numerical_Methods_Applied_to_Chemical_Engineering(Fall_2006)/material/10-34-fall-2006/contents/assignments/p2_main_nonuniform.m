% 10.34 - Fall 2006
% Hw Set #8 - Problem #2
% Rob Ashcraft - Oct. 25, 2006


% reaction in a spherical catalyst particle

function p2_main_nonuniform

clear;

global Ds_gel S_bulk rate_0 Km

Nr_vec = [101];
    
Sh = 10;

R_vec = [0.0005, 0.001, 0.005];

%R_vec = logspace(log10(2e-4), log10(0.02), 21)'
%R_vec = linspace(2e-4, 0.02, 21)';


S_bulk = 1000;  % moles/m^3

rhoE = 0.01*1e6;  % mgE/m^3 gel
Ds_gel = 1e-10;  % m^2/s
Ds_liq = 7e-10;  % m^2/s

Vm = 200/60/1e6;  % mole/s-mgE
Km = 200;  % mole/m^3

rate_0 = Vm*rhoE;  % mole/m^3-s

S_vec = zeros(max(Nr_vec),length(R_vec));


for ct = 1:length(R_vec)
    
    Nr = Nr_vec(1);
    
    R = R_vec(ct);

    k_mass(ct) = Sh*Ds_liq/(2*R);    % m/s

    V_total(ct) = 4/3*3.1415*R^3;
    dV = V_total(ct)/(Nr-1);
    r(1,ct) = 0;
    for i=2:Nr 
        r(i,ct) = (3*dV/(4*3.1415) + r(i-1,ct)^3)^(1/3);  % not scaled to problem
        dr(i-1,ct) = r(i,ct) - r(i-1,ct);   % not scaled to problem
    end
%     for i=1:Nr
%         if(i == 1)
%             r_temp(i,ct) = 0;
%             dr_temp(i,ct) = 0.01;
%         else
%             r_temp(i,ct) = r_temp(i-1,ct) + dr_temp(i-1,ct);  % not scaled to problem
%             dr_temp(i,ct) = dr_temp(i-1,ct)/1.01;   % not scaled to problem
%         end
%     end
% 
%     r(:,ct) = r_temp(:,ct)*(R/r_temp(end,ct));  % scale it to the appropriate length in the problem
%     dr(:,ct) = dr_temp(:,ct)*(R/r_temp(end,ct));
    
    dr(1,ct)/dr(end,ct)
    
    options=optimset('display','off','tolfun',1e-12,'tolx',1e-12,'MaxFunEvals',100000,'MaxIter',1000);
        
    if(ct == 1)
        var_guess = linspace(0,1000,Nr)';
    else
        var_guess = S_guess(:,ct-1);
    end
    S_guess(1:Nr,ct) = fsolve(@fin_diff_eqn_const,var_guess,options,Nr,r(:,ct),dr(:,ct),k_mass(ct));

    options=optimset('display','off','tolfun',1e-12,'tolx',1e-12,'MaxFunEvals',100000,'MaxIter',1000);
    var_0 = S_guess(:,ct);
    S_vec(1:Nr,ct) = fsolve(@fin_diff_eqn,var_0,options,Nr,r(:,ct),dr(:,ct),k_mass(ct));
    resid(:,i)=fin_diff_eqn(S_vec(:,ct),Nr,r(:,ct),dr(:,ct),k_mass(ct));
    resid(1)
    resid(end)
end

max(S_vec)

for i=1:length(R_vec)
    cons_rate(i) = k_mass(i)*(S_bulk - S_vec(end,i))*4*3.1415*R_vec(i)^2;    % moles/sec
    cons_rate_in(i) = Ds_gel*(S_vec(end,i) - S_vec(end-1,i))/dr(end-1,i)*4*3.1415*R_vec(i)^2;    % moles/sec
    mass_E(i) = 4/3*3.1415*R_vec(i)^3 * rhoE;  % mgE per bead
    mole_per_kgE(i) = cons_rate(i)/mass_E(i)*1e6;     % moles/mgE-sec
    mole_per_kgE_in(i) = cons_rate_in(i)/mass_E(i)*1e6;     % moles/mgE-sec
    
    disp(['Consumption Rate Out for R = ',num2str(R_vec(i)),' m:  ',num2str(mole_per_kgE(i)),' moles S per kg E']);
    disp(['Consumption Rate In for R = ',num2str(R_vec(i)),' m:  ',num2str(mole_per_kgE_in(i)),' moles S per kg E']);

    r_scaled(:,i) = r(:,i)/R_vec(i);
end
k_mass;

%plot(r,dr);

figure; plot(R_vec,mole_per_kgE,'o');

figure;
plot(r(:,1)/R_vec(1),S_vec(:,1),'-o',r(:,2)/R_vec(2),S_vec(:,2),'-.',r(:,3)/R_vec(3),S_vec(:,3),'--');
xlabel('r/R  (scaled radius)'); ylabel('Concentration  (mole/m^3)');
legend('R = 0.5 mm','R = 1.0 mm','R = 5.0 mm');

% figure;
% plot(S_vec)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function resid = fin_diff_eqn(var,Nr,r,dr,k_mass)

global Ds_gel S_bulk rate_0 Km

S = var;

for i=1:Nr
    
    if(i == 1)
        dr12 = dr(i);
        dr13 = dr(i) + dr(i+1);
        resid(i) = (S(i)*(dr13^2 - dr12^2) - (S(i+1)*dr13^2 - S(i+2)*dr12^2))*1e9;
        
    elseif(i == Nr)  % BC @ r=R: Dgel*dS/dr = k_mass*(S_bulk - S(r=R))
        resid(i) = ((S(i) - S(i-1))/dr(i-1) - (k_mass/Ds_gel*(S_bulk - S(i))))*1e9;
        %resid(i) = (S(i) - 1000);
        
    else
%          resid(i) = r(i)/(dr(i-1)*dr(i))*(S(i+1) - 2*S(i) + S(i-1))...
%              + 2/(dr(i-1)+dr(i))*(S(i+1) - S(i-1))...
%              - r(i)*rate_0/Ds_gel*S(i)/(Km+S(i));
        resid(i) = r(i)*( (S(i+1) - S(i))/dr(i) - (S(i) - S(i-1))/dr(i-1) )/(dr(i)/2 + dr(i-1)/2)...
            + 2*( (S(i+1) - S(i))*dr(i-1)/dr(i) + (S(i) - S(i-1))*dr(i)/dr(i-1) )/(dr(i-1)+dr(i))...
            - r(i)*rate_0/Ds_gel*S(i)/(Km+S(i));
    end
end

return;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function resid = fin_diff_eqn_const(var,Nr,r,dr,k_mass)

global Ds_gel S_bulk rate_0 Km

S = var;

for i=1:Nr
    
    if(i == 1)
        resid(i) = S(i) - S(i+1);
        
    elseif(i == Nr)  % BC @ r=R: Dgel*dS/dr = k_mass*(S_bulk - S(r=R))
        resid(i) = (S(i) - 1000);
        
    else
%          resid(i) = r(i)/(dr(i-1)*dr(i))*(S(i+1) - 2*S(i) + S(i-1))...
%              + 2/(dr(i-1)+dr(i))*(S(i+1) - S(i-1))...
%              - r(i)*rate_0/Ds_gel*S(i)/(Km+S(i));
        resid(i) = r(i)*( (S(i+1) - S(i))/dr(i) - (S(i) - S(i-1))/dr(i-1) )/(dr(i)/2 + dr(i-1)/2)...
            + 2*( (S(i+1) - S(i))*dr(i-1)/dr(i) + (S(i) - S(i-1))*dr(i)/dr(i-1) )/(dr(i-1)+dr(i))...
            - r(i)*rate_0/Ds_gel*S(i)/(Km+S(i));
    end
end

return;    
    
    
    
    