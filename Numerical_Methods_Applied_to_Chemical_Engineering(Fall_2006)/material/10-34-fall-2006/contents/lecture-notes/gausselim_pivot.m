function [U,v]=gausselim_pivot(A,b)
% Gaussian elimination algorithm with partial pivoting
%   converts a system of linear equations A*x=b to an
%   equivalent upper triangular system U*x=v
% by W.H.Green 9/10/06
M=[A b]%form the augmented matrix
N=length(b);
for i=1:(N-1)
    % this block does partial pivoting (swapping rows)
    [Y jbig]=max(abs(M(i:N,i))); %find the biggest element
            % in column i, starting from M(i,i)
            % jbig is the index of the biggest element
            jbig=jbig+i-1; % needed since index offset by i.
           Vtemp=M(i,:); % temporarily store ith row of M 
           M(i,:)=M(jbig,:); %swap
           M(jbig,:)=Vtemp;
    %end of the partial pivoting
    for j=(i+1):N % the rows below the i,i element
        lambda=M(j,i)./M(i,i);  
        for k=i:(N+1) % the elements to the right of col i
            M(j,k)=M(j,k)-lambda.*M(i,k);
        end
    end
end
%unpack the augmented matrix
U=M(:,1:N);
v=M(:,N+1);