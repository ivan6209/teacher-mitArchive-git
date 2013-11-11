function [U,v]=gauss(A,b)
% uses Gaussian elimination to convert Ax=b to Ux=v 
%  where U is upper triangular
%  assumes A is NxN matrix
%          b is Nx1 column vector
N=length(b);
M=[A b]; % make augmented matrix
for i=1:(N-1)
    for j=(i+1):N
        lambda=-M(j,i)/M(i,i);
        M(j,:)=M(j,:)+lambda*M(i,:);
    end
end
% unpack modified augmented matrix
U=M(:,1:N);
v=M(:,N+1);
    