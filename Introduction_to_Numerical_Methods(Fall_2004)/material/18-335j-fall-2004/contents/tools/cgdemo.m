n=100;
tol=1e-12;
A=diag([1:n])+diag(ones(n-1,1),1)+diag(ones(n-1,1),-1);
A=A+diag(ones(n/2,1),n/2)+diag(ones(n/2,1),-n/2);

b=ones(n,1);
[x,flag,relres,iter,resvec]=pcg(A,b,tol,100);
semilogy(resvec); hold on
pause

[x,flag,relres,iter,resvec]=pcg(A,b,tol,100,diag(diag(A)));
semilogy(resvec,'r');
pause

A=sparse(A);
R=cholinc(A,'0');
[x,flag,relres,iter,resvec]=pcg(A,b,tol,100,R',R);
semilogy(resvec,'g');


A=full(A);

R=full(R);

[cond(A) cond(inv(diag(diag(A)))*A) cond(inv(R'*R)*A)]