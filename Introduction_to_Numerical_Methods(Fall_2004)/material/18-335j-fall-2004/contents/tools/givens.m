function [Q,A]=Givens(A);
n=size(A,1);

Q=eye(n);
for j=1:n-1
   for i=n:-1:j+1
      z=1/sqrt(A(i-1,j)^2+A(i,j)^2);
      c=A(i-1,j)*z;
      s=A(i,j)*z;
      A(i-1:i,:)=[c s; -s c]*A(i-1:i,:);
      Q(i-1:i,:)=[c s; -s c]*Q(i-1:i,:);
      A
      pause
   end
end
