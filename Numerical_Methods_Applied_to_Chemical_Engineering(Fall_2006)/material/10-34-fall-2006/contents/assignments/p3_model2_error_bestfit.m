function [params,res] = model2_error_bestfit()
%calculates the best fit value of all the parameters and then plots the
%histogram of errors

S = readS_matrix();
sizeS = size(S);
l = linspace(432,481,sizeS(2));
time = linspace(0,100,sizeS(1));

rms_error = 4.857e-4;
%initial guesses for the best fit parameters calculated from previous
%estimates
k1 = 0.0497; k2 = 0.0303; Kb1 = 0.3; Kb2 = 0.0501; 
Kc1 = 0.7339; lb1 = 450.62; lb2 = 469.23; lc1 = 439.844; wb1 = 3.1041; 
wb2 = 9.7590; wc1 = 6.94;

%initial guess for the program
params0(1) = k1; params0(2) = k2; params0(3) = Kb1; params0(4) = Kb2;
params0(5) = Kc1; params0(6) = lb1; params0(7) = lb2; params0(8) = lc1; params0(9) = wb1;
params0(10) = wb2; params0(11) = wc1;

%perform the optimization
options= optimset('MaxFunEvals',10^4,'Display','iter','TolX',1e-6,'TolFun',1e-6);
[params, fval] = fminsearch(@S_error, params0,options,S);


%plot the residuals
res = zeros(sizeS(1)*sizeS(2),1);

k1 = params(1); k2 = params(2); Kb1 = params(3); Kb2 = params(4);
Kc1 = params(5); lb1 = params(6); lb2 = params(7); lc1 = params(8); wb1 = params(9);
wb2 = params(10); wc1 = params(11);

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

for i=1:sizeS(1)
    for j = 1:sizeS(2)
        res(sizeS(2)*(i-1)+j) = S(i,j) - S_model(i,j);
    end
end

%x = linspace(-2e-3,2e-3,40);

[n,x]=hist(res,40);
bar(x,n);
title('Distribution of error due to Model-2');
xlabel('Magnitude of Error');
ylabel('Frequency of the Error');

norm= zeros(1,40);
for i=2:length(x)
    norm(i) = normcdf(x(i),0,rms_error) - normcdf(x(i-1),0,rms_error);
end
norm(1) = normcdf(x(1),0,rms_error);
norm = norm*5151;


hold;
plot(x,norm,'r'); legend('Expt. Error distribution','Exact normal distribution');

chi2 = 0;
std_dev = 4.8570e-004;
for i=1:length(res)
    chi2 = chi2 + res(i)^2;%/std_dev^2;
end

chi2 = chi2/std_dev^2
significance = 1 - chi2cdf(chi2, (length(res)-11))

return;

%*************************************************************************

function res = S_error(params,S)

k1 = params(1); k2 = params(2); Kb1 = params(3); Kb2 = params(4);
Kc1 = params(5); lb1 = params(6); lb2 = params(7); lc1 = params(8); wb1 = params(9);
wb2 = params(10); wc1 = params(11);
res = 0;
sizeS = size(S);

l = linspace(432,481,sizeS(2));
time = linspace(0,100,sizeS(1));

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

for i=1:sizeS(1)
    for j = 1:sizeS(2)
        res = res + (S(i,j) - S_model(i,j))^2;
    end
end

return;