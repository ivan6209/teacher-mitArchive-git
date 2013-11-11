function [Cp,H,S]=Shomate(T,molecule_data)
% Program to compute thermo stored as Shomate coefficients
% W.H. Green, 9/27/02
% Outputs:
%     1) constant-pressure heat capacity Cp in J/mol K
%     2) enthalpy in kJ/mol 
%     3) entropy in J/mol K
%   Note, if T is a vector, these will all be vectors of the same shape.
% Inputs: T in K, molecule_data = [A B C D E F G Tmin Tmax]'
%     A-G, Tmin, Tmax from NIST Webbook http://webbook.nist.gov
%     in Joule/mole Kelvin units
% Cp0= A + B*t + C*t^2 + D*t^3 + E/t^2
% H0= A*t + B*t^2/2 + C*t^3/3 + D*t^4/4 - E/t + F
% S0= A*ln(t) + B*t + C*t^2/2 + D*t^3/3 - E/(2*t^2) + G
% Tmin and Tmax define the range over which 
%   these A-G are accurate
% Sometimes there are different parameter sets for different T ranges
%   if so, make molecule_data a matrix, with a column for each T range.
%  First: figure out how many parameter sets we have
%          and how many T's the user has input
dim_molecule_data=size(molecule_data);
number_of_parameter_sets=dim_molecule_data(2);
dim_T=size(T);
number_of_T=dim_T(1);
Cp=-1e20*ones(dim_T);   % if you see any -1e20's in output, something went wrong
H=Cp;                   % most likely your T was outside the T range where the
S=Cp;                   % Shomate fit is valid.
for i=1:number_of_parameter_sets
    Tmin=molecule_data(8,i); Tmax=molecule_data(9,i);
    for j=1:number_of_T
     if((T(j)>=Tmin)&(T(j)<=Tmax))
        A = molecule_data(1,i); B=molecule_data(2,i);
        C = molecule_data(3,i); D=molecule_data(4,i);
        E = molecule_data(5,i); F=molecule_data(6,i);
        G = molecule_data(7,i);
        t=0.001*T(j);  % NIST t= T/1000 Kelvin
        Cp(j,1)=A+(B*t)+(C*t*t)+(D*(t^3))+(E/(t*t)); 
        H(j,1)=(A*t)+(0.5*B*t*t)+(C*(t^3)/3)+(0.25*D*(t^4))-(E/t)+F;
        S(j,1)=(A*log(t))+(B*t)+(0.5*C*t*t)+(D*(t^3)/3)-(0.5*E/(t*t))+G;
     end
    end
end
% if any of the values are -1e20, it means that the Shomate polynomial
%  was not valid in the requested T range.
% 
% Sample input
% For H2
% H2_data=[33.10780 -11.50800 11.60930 -2.844400 -0.159665 -9.991971 172.7880 298 1500]';
% By running [Cp,H,S]=Shomate(300, H2_data);
%
% Sample output
% » Cp
% Cp =
%    28.8494
% » H
% H =
%    0.0534
% » S
% S =
%  130.8586

