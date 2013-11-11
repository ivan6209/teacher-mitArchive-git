function k = rate(T,params)
% computes rate constant given temperature and Arrhenius parameters
% Bill Green 9/8/06
% inputs:
%   T [=] Kelvin
%   params = [A; n; Ea]
%       A [=] 1/second
%       n  unitless exponent
%      Ea [=] kJ/mole
% output:
%   k [=] 1/second
%
% unpack params
A=params(1);
n=params(2);
Ea=params(3);
R = 8.314; % gas constant J/mole-Kelvin
Ea=1000.*Ea;
k=A.*(T.^n).*exp(-Ea./(R.*T));
%Tvec=linspace(300,1200);
%params=[1e9;0.5;82];
%kvec=rate(Tvec,params);
%kvec(3)
%ans =
%  6.1551e-004
