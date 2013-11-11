function p4(params)
rms_error = 4.8570e-004;

S = readS_matrix();

k1 = 0.0500; k2 = 0.0250; Kb1 = 0.2999; Kb2 = 0.0502; 
Kc1 = 0.7999; lb1 = 450.6207; lb2 = 469.2300; lc1 = 439.8405; wb1 = 3.1029; 
wb2 = 9.7590; wc1 = 6.9302;

params0(1) = k1; params0(2) = k2; params0(3) = Kb1; params0(4) = Kb2;
params0(5) = Kc1; params0(6) = lb1; params0(7) = lb2; params0(8) = lc1; params0(9) = wb1;
params0(10) = wb2; params0(11) = wc1;

n=41;
k1_array = linspace(params(1)*0.9987, params(1)*1.0013, n);
k2_array = linspace(params(2)*0.9997, params(2)*1.0003, n);

chi2 = zeros(n,n);

chi = calculatechi2(params(1), params(2), params,S)/rms_error^2

for i=1:n
    for j=1:n
        chi2(i,j) = calculatechi2(k1_array(i),k2_array(j),params,S)/rms_error^2;
    end
end


conf95 = chi2inv(0.95, 2);
conf90 = chi2inv(0.90, 2);
%v = [chi0+conf95; chi0+conf99];
v = [chi+conf90; chi+conf95];


pcolor(k1_array, k2_array, chi2');xlabel('k1');ylabel('k3');shading interp;colorbar;

figure;
[C,h] = contour(k1_array, k2_array, chi2',v);xlabel('k1');ylabel('k3');%shading interp;colorbar;
set(h,'ShowText','on');


return;


%*************************************************************************

function chi2 = calculatechi2(k1, k2, params, S);

Kb1 = params(3); Kb2 = params(4);
Kc1 = params(5); lb1 = params(6); lb2 = params(7); lc1 = params(8); wb1 = params(9);
wb2 = params(10); wc1 = params(11);

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

chi2 = 0;
for i=1:sizeS(1)
    for j = 1:sizeS(2)
        chi2 = chi2 + (S(i,j) - S_model(i,j))^2;
    end
end

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