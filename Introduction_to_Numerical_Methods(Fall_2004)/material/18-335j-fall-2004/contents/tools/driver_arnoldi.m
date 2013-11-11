n = 100;
m = 100;

%A = sprandn(n,n,0.1);
randn('seed',1999); 
A = randn(n,n); 

v = randn(n,1);

%Arnoldi process
[H,V,flag]=arnoldi(A,v,m);

Heig = eig(H(1:m,1:m));

% compute all eigenvalues
Aeig = eig(full(A));

plot(real(Aeig),imag(Aeig),'b+')
hold on;
plot(real(Heig),imag(Heig),'ro')
hold off;
xlabel('Real Part')
ylabel('Imaginary Part')
title('Eigenvalues of A in "+" and H_{30} in "o"')

