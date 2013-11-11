function E = pset4problem2b(M,I)
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

%Display the zero-point energy of the system.
output = strcat('The zero point energy of the system = ',num2str(E(1)),' J\n');
fprintf(output);

phi = linspace(-0.1, 2.1*pi);
plotV(y,phi);
hold;
for n=1:length(E)
    x = [0; 2*pi];
    y = [E(n),E(n)];
    plot(x,y,'r');
end
title('Eigenvalues of hamiltonian');
xlabel('Angle (radians)');
ylabel('Energy (J/molecule)');
return;

%***********************************************************
function plotV(y,phi)

V = zeros(length(phi),1);
for n=1:length(phi)
    for m = 1:length(y)
        V(n) = V(n) + y(m)*cos((m-1)*phi(n)) ;
    end
end

plot(phi,V);
return;


