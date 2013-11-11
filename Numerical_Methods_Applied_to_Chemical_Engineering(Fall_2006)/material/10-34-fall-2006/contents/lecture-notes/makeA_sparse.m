function A_sparse=makeA_sparse(Nx,Ny,Xmax,Ymax)
% makes the matrix A so that A*phi is the finite difference
% approximation for del^2(phi).
%  Assumes rectangular mesh Nx by Ny uniformly spaced mesh points
%    running from (0,0) to (Xmax,Ymax)
% indexing: function value at (x_i,y_j) is phi((i-1)*Ny+j)
% current version assumes function = 0 on the boundaries
dX=Xmax/Nx;  dY=Ymax/Ny;
invdX2=1./(dX.*dX);
invdY2=1./(dY.*dY);
NxNy=Nx.*Ny;
counter=0;
for i=1:Nx
    for j=1:Ny
        n=j+(i-1)*Ny;
        counter=counter+1;
        mvec(counter)=n;
        nvec(counter)=n;
        Avec(counter)=-2*(invdX2+invdY2);
%        A(n,n)=-2*(invdX2+invdY2); 
        if(i<Nx)
            ni=n+Ny; % index for (x_i+1,y_j)
            counter=counter+1;
            mvec(counter)=n;
            nvec(counter)=ni;
            Avec(counter)=invdX2;
 %           A(n,ni)=invdX2;
        end
        if(i>1)
            n_i=n-Ny;  % index for (x_i-1,y_j)
            counter=counter+1;
            mvec(counter)=n;
            nvec(counter)=n_i;
            Avec(counter)=invdX2;
%            A(n,n_i)=invdX2;
        end
        if(j<Ny)
            nj=n+1; %index for (x_i,y_j+1)
            counter=counter+1;
            mvec(counter)=n;
            nvec(counter)=nj;
            Avec(counter)=invdY2;
 %           A(n,nj)=invdY2;
        end
        if(j>1)
            n_j=n-1;
            counter=counter+1;
            mvec(counter)=n;
            nvec(counter)=n_j;
            Avec(counter)=invdY2;
 %           A(n,n_j)=invdY2;
        end
    end
end
A_sparse=sparse(mvec,nvec,Avec);
        