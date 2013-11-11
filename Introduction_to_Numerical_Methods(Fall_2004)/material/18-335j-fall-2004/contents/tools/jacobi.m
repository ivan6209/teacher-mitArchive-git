function A=Jacobi(A);
n=size(A,1);


for k=1:10
for j=1:n-1
   for i=n:-1:j+1
      tau=(A(j,j)-A(i,i))/2/A(i,j);
      t=sign(tau)/(abs(tau)+sqrt(1+tau^2));
      c=1/sqrt(1+t^2);
      s=c*t;
      A([i j],:)=[c -s; s c]*A([i j],:);
      A(:,[i j])=A(:,[i j])*[c s; -s c];
      B=A-diag(diag(A));
      A
      s=sum(sum(abs(B).^2))
      pause
   end
end
end
