function r = reactionRate(ca,cb,cc, params)
%calculates the rate of reaction
%input:
%       ca, cb ,cc concentrations of a, b and c
%       params is the structure of all parameters
%output:
%       r is the rate of the reaction

%unpack the parameter
k = params.k; %rate constant
K = params.K; %equilibrium constant

r = k*(ca*cb - cc/K);
return