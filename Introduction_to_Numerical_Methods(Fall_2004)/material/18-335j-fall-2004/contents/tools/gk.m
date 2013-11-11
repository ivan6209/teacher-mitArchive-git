function A=gk(A);
A
n=size(A,1);
for i=1:n-1
  u=A(i:n,i);
  u(1)=u(1)+sign(u(1))*norm(u);
  u=u/norm(u);
  
  A(i:n,i:n)=A(i:n,i:n)-2*u*(u'*A(i:n,i:n));
  
  u=A(i,i+1:n)';
  u(1)=u(1)+sign(u(1))*norm(u);
  u=u/norm(u);
  
  A(i:n,i+1:n)=A(i:n,i+1:n)-2*A(i:n,i+1:n)*u*u';
  A
  pause
  
end