function [fAverage,accepted,q_all,f_val,f_val_sqr,RHH_val,X_all,Y_all,Z_all,V_all] = Metropolis(f,T,q0,N,del)
% computes average f(q) for Boltzmann V(q), temperature T (Kelvin) 
% using N points starting from q0
% 
% "f" is a function that return the value of interest <1/R_HH^6>
%  T is the temperature
%  q0 is the initial geometry of the system (6 degrees of freedom)
%  N is the number of MC steps
%  del is the maximum step size in any one coordinate

% O1 = (0,0,0)
% O2 = (xO2,0,0)
% H1 = (xH1,yH1,0);
% xO2=q(1);  %all x,y,z in Angstroms
% xH1=q(2); yH1=q(3);
% xH2=q(4); yH2=q(5); zH2=q(6);

Delta=del*ones(size(q0)); % adjusting Delta changes heuristics
invkT=1/(1.3807e-11*T); %[=] 1/picoJoule

Vcurrent=V(q0); % V must have units pJ/molecule
q=q0;
w_current = q(1)^2*abs(q(3))*exp(-invkT*Vcurrent);  %initial weighting factor

sizeq=size(q);
accepted=0;  % initialize "accepted" at zero

% allocate vectors to store values
f_val = zeros(N,1);
fAverage = zeros(N,1);
RHH_val = zeros(N,1);
q_all = zeros(N,6);

X_all = zeros(N,4);
Y_all = zeros(N,4);
Z_all = zeros(N,4);

for i=1:N
    qtry = q + Delta.*(rand(sizeq)-0.5)*2;  % take a step to get a new orientation
    [junk,Vtry] = V(qtry);  % evaluate the energy in pJ at this new point
    w_try = qtry(1)^2*abs(qtry(3))*exp(-invkT*Vtry);  % the weight at the new point
    
    if(Vtry<Vcurrent)  % accept the step if it is downhill
        accepted = accepted+1;
        f_val(i) = feval(f,qtry);
        Vcurrent = Vtry;
        q = qtry;  % assign the new q value
    elseif( w_try/w_current > rand(1) )   % accept an uphill step based on the ratio of weights 
        accepted = accepted+1;
        f_val(i) = feval(f,qtry);
        Vcurrent = Vtry;
        q = qtry;   % assign the new q value
    else
        % rejected, don't update the q value (take old one again)
        f_val(i) = feval(f,q);
    end
    
    w_current = q(1)^2*abs(q(3))*exp(-invkT*Vcurrent);  % calculate weight at new point
    
    % store various quantities
    q_all(i,:) = q';
    V_all(i) = Vcurrent;
    fAverage(i) = sum(f_val(1:i))/i;  % this average is updated at each step
    
    f_val_sqr(i) = f_val(i)^2;  % this is the (1/R_HH^6)^2 value
    
    % store the atom positions at each MC step to use in plots
    % atoms:      H1       O1      O2      H2
    X_all(i,:) = [q(2)    ,0      ,q(1)   ,q(4)];
    Y_all(i,:) = [q(3)    ,0      ,0      ,q(5)];
    Z_all(i,:) = [0       ,0      ,0      ,q(6)];
    
    RHH_val(i) = (1/f_val(i))^(1/6);  % calculate the H-H distance
end

