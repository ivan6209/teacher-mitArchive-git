function [CI] = model2_param_est()
%calculates the best fit value of all the parameters and then plots the
%histogram of errors

S = readS_matrix();
sizeS = size(S);
l = linspace(432,481,sizeS(2));
time = linspace(0,100,sizeS(1));

%initial guesses for the best fit parameters calculated from previous
%estimates
k1 = 0.0497; k2 = 0.0303; Kb1 = 0.3; Kb2 = 0.0501; 
Kc1 = 0.7339; lb1 = 450.62; lb2 = 469.23; lc1 = 439.844; wb1 = 3.1041; 
wb2 = 9.7590; wc1 = 6.94;

%initial guess for the program
params0(1) = k1; params0(2) = k2; params0(3) = Kb1; params0(4) = Kb2;
params0(5) = Kc1; params0(6) = lb1; params0(7) = lb2; params0(8) = lc1; params0(9) = wb1;
params0(10) = wb2; params0(11) = wc1;

b = zeros(length(time)*length(l),1);
X = zeros(length(time)*length(l),2);  %(time, lambda)
%convert S matrix to b vector
for i=1:length(time);
    for j=1:length(l)
        b((i-1)*length(l)+j) = S(i,j);
        X((i-1)*length(l)+j, 1) = l(j) ;
        X((i-1)*length(l)+j, 1) = time(i);
    end
end

%perform the optimization
options= optimset('MaxFunEvals',10^4,'Display','iter','TolX',1e-10,'TolFun',1e-10);
[params,residuals, Jac] = nlinfit(X,b,@S_error, params0,options);
[CI] = nlparci(params,residuals,Jac);

output = strcat('k1 confidence intervals :', num2str(CI(1,1)),'\t',num2str(CI(1,2)),'\n');
fprintf(output);
output = strcat('k2 confidence intervals :', num2str(CI(2,1)),'\t',num2str(CI(2,2)),'\n');
fprintf(output);

return;

function y_hat = S_error(params,X)
k1 = params(1); k2 = params(2); Kb1 = params(3); Kb2 = params(4);
Kc1 = params(5); lb1 = params(6); lb2 = params(7); lc1 = params(8); wb1 = params(9);
wb2 = params(10); wc1 = params(11);
res = 0;


S = readS_matrix();
sizeS = size(S);
l = linspace(432,481,sizeS(2));
time = linspace(0,100,sizeS(1));

y_hat = zeros(length(time)*length(l),1);

cb = 0*time; cc = 0*time;

for i=1:length(time)
    cb(i) = exp(-k1*time(i));
    cc(i) = (1 - exp(-k2*time(i)));
end

Ab = 0*l; Ac = 0*l;
for i=1:length(l)
    Ab(i) = Kb1 * exp(-(l(i) - lb1)^2/wb1^2) + Kb2 * exp(-(l(i) - lb2)^2/wb2^2);
    Ac(i) = Kc1 * exp(-(l(i) - lc1)^2/wc1^2);
end

S_model = cb'*Ab + cc'*Ac;

for i=1:length(time)
    for j = 1:length(l)
        y_hat((i-1)*length(l)+j) = S_model(i,j);
    end
end



return;