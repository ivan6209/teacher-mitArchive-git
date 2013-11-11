function [params] = fitAbsForC()%Ab, l)
%fits the absoption Ab to the form 
%Ab = A1 * exp((l - l1)^2/w1^2)  and determines
%the values of A1,  l1,  w1 
% input: Ab: a vector of absoptions
%         l: a vector of wavelengths at which the absoptions Ab are
%         measured
%output: params: A1,  l1,  w1, 


S = readS_matrix();
[W,Sigma,V] = svd(S);
sizeS = size(S);
l = linspace(432,481,sizeS(2));
Ab = S(101,:);

%initial guesses
l10 = 440;  w10 = 5;  A1 = 0.3; 

%initial guesses in optimization
params0 = [l10; w10; A1];

options = optimset('MaxFunEvals',10^4,'Display','iter');
params = fminunc(@myfunforabsA,params0,options,Ab,l);

l1 = params(1); w1 = params(2); A1 = params(3);

fitl = zeros(length(l),1);
for i=1:length(l)
    fitl(i) = A1 * exp(-(l(i) - l1)^2/w1^2) ;
end

figure;
plot(l,fitl,'.-',l,S(101,:),'o'); legend('Best Fit Absorption of C','Signal at t=100 s');
title('The absoption spectrum of species C');
xlabel('The wavelength (nm)');
ylabel('The Absorption');

return;

function res = myfunforabsA(params, Ab, l)

%unpack the parameters
l1 = params(1); w1 = params(2); A1 = params(3); 

res = 0;
for i=1:length(l)
    res = res + (Ab(i) - A1 * exp(-(l(i) - l1)^2/w1^2))^2;
end

return;