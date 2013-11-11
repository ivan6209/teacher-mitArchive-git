function A=house(A);
A
n=size(A,1);
for i=1:n-1
  u=A(i:n,i);
  u(1)=u(1)+sign(u(1))*norm(u);
  
  A(i:n,i:n)=A(i:n,i:n)-2*u*(u'*A(i:n,i:n))/(u'*u);
  A
  pause
end