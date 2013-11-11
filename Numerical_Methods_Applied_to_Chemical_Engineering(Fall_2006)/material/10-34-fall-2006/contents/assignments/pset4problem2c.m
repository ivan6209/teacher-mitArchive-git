function C = pset4problem2c(T,M)
%This function evaluates the heat capacities at a given temperature given
%the size of the basis set M to use
% Input:
%       T: vector of Temperatures at which the value of heat capacity is required
%       M: The size of the basis set used
%Output:
%       C: The vector of heat capacity at each temperature in the vector T

%For a given value of M we can calculate 2*M+1 values of energies
% we use problem2b to solve for the energies

I = 3e-45; %the moment of inertia Kg-m2
kb = 1.38e-23; %boltzmann constant

%calculate the energies of the system
E = calculateE(M,I);

%loop over all the temperatures and calculate the values of C for each
%temperature and store it in the vector C.
for k=1:length(T)
    E_avg = 0;
    E2_avg = 0;
    denominator = 0;

    for n=1:length(E)
        E_avg = E_avg + E(n)*exp(-E(n)/kb/T(k));
        E2_avg = E2_avg + E(n)^2*exp(-E(n)/kb/T(k));
        denominator = denominator + exp(-E(n)/kb/T(k));
    end
    C(k) = (E2_avg/denominator - (E_avg/denominator)^2)/kb/T(k)^2;
end

%convert the units of C from J/molecule/K to J/mol/K by multiplying by
%Avagadro number
C = C*6.023e23; 
return;

%**********************************************************************

function E = calculateE(M,I)
%calculates the energies of the system given the size of the basis function
% written by Sandeep Sharma on 26th Sep 2006
%Taken input 
%       M which is the size of the basis function to be used
%       I the angular moment of the hindered rotor
%outputs the vector of energies.

%Start by defining all the constants
h = 6.625e-34;  %J-s


%get the coefficients ys of the potential function
%y = [2.0667 -2.0333 1.2333 -1.7667 0.5]'*1e-19;
y = [2.067 -2.033 1.056 -1.767 0.678]'*1e-20;

%fill the elements due to the differential operators
for n=1:2*M+1
    H(n,n) = h^2*(n-M-1)^2/8/pi^2/I;
end

%fill in the elements for on the upper triagular side and diagonal of the matrix.

for n=1:2*M-3
    H(n,n) = H(n,n) + y(1);
    H(n,n+1) = y(2)/2;
    H(n,n+2) = y(3)/2;
    H(n,n+3) = y(4)/2;
    H(n,n+4) = y(5)/2;
end
H(2*M-2,2*M-2) = H(2*M-2,2*M-2) + y(1);
H(2*M-2,2*M-1) = y(2)/2;
H(2*M-2,2*M)  = y(3)/2;
H(2*M-2,2*M+1) = y(4)/2;

H(2*M-1,2*M-1) = H(2*M-1,2*M-1) + y(1);
H(2*M-1,2*M) = y(2)/2;
H(2*M-1,2*M+1) = y(3)/2;

H(2*M,2*M) = H(2*M,2*M) + y(1);
H(2*M,2*M+1) = y(2)/2;

H(2*M+1,2*M+1) = H(2*M+1,2*M+1) + y(1);

%fill in the elements on the lower triangular part of the matrix.

for n= 5:2*M+1
    H(n,n-1) = y(2)/2;
    H(n,n-2) = y(3)/2;
    H(n,n-3) = y(4)/2;
    H(n,n-4) = y(5)/2;
end
H(2,1) = y(2)/2;

H(3,2) = y(2)/2;
H(3,1) = y(3)/2;

H(4,3) = y(2)/2;
H(4,2) = y(3)/2;
H(4,1) = y(4)/2;

%The eigenvalues of matrix H are the allowed energy states of the system
E = eig(H);


return;