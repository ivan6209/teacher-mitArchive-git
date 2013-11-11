function [params] = fitAbsForB()%Ab, l)
%fits the absoption Ab to the form 
%Ab = A1 * exp((l - l1)^2/w1^2) + A2 * exp((l - l2)^2/w2^2) and determines
%the values of A1, A2, l1, l2, w1 and w2
% input: Ab: a vector of absoptions
%         l: a vector of wavelengths at which the absoptions Ab are
%         measured
%output: params: A1, A2, l1, l2, w1, w2


S = readS_matrix();
[W,Sigma,V] = svd(S);
sizeS = size(S);
l = linspace(432,481,sizeS(2));
Ab = S(1,:);

%initial guesses
l10 = 450; l20 = 470; w10 = 2; w20 = 5; A1 = 0.3; A2 = 0.03;

%initial guesses in optimization
params0 = [l10; l20; w10; w20; A1; A2];

options = optimset('MaxFunEvals',10^4,'Display','iter');
params = fminunc(@myfunforabsA,params0,options,Ab,l);

l1 = params(1); l2 = params(2); w1 = params(3); w2 = params(4); A1 = params(5); A2 = params(6);

fitl = zeros(length(l),1);
for i=1:length(l)
    fitl(i) = A1 * exp(-(l(i) - l1)^2/w1^2) + A2 * exp(-(l(i) - l2)^2/w2^2);
end

figure;
plot(l,fitl,'.-',l,S(1,:),'o'); legend('Best Fit Absorption of B','Signal at t=0');
title('The absoption spectrum of species B');
xlabel('The wavelength (nm)');
ylabel('The Absorption');

return;

function res = myfunforabsA(params, Ab, l)

%unpack the parameters
l1 = params(1); l2 = params(2); w1 = params(3); w2 = params(4); A1 = params(5); A2 = params(6);

res = 0;
for i=1:length(l)
    res = res + (Ab(i) - A1 * exp(-(l(i) - l1)^2/w1^2) - A2 * exp(-(l(i) - l2)^2/w2^2))^2;
end

return;