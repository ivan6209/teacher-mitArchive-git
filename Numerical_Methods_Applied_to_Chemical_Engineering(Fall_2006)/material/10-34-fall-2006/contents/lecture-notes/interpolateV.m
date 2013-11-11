function [y,y_conventional]= interpolateV(N,Vphi,phi)
% Computes y that interpolate/fit V(phi)=Sum y'*cos(N.*phi)
% by Bill Green 10/1/06
% inputs:
%     N is a vector with the values of N to use
%     Vphi is a vector V(phi)
%     phi is a vector with the phi values (radians) 
%                where Vphi values are known
% output:
%     y is a vector of the interpolating or best-fit coefficients
A =zeros(length(phi),length(N));
for j=1:length(N)
    for k=1:length(phi)
        A(k,j) = cos(N(j)*phi(k));
    end
end
condA=cond(A)
% if(condA)<1000
    y_conventional = A \ Vphi;
%else
    [U,S,V]=svd(A);
    S
    y=zeros(length(N),1);
    for i=1:min(size(S))
        if(S(i,i)>0.001)
            i
            y = y + ((U(:,i)'*Vphi)./S(i,i)).*V(:,i);
        end
    end
%end
Vnew = A*y;
V_conventional = A*y_conventional;
[Vphi Vnew V_conventional]


% added by Rob Ashcraft - 10/2/06
phi_plot = linspace(0,2*pi);
for j=1:length(N)
    for k=1:length(phi_plot)
        A_plot(k,j) = cos(N(j)*phi_plot(k));
    end
end

V_conv = A_plot*y_conventional;

V_svd = A_plot*y;

figure;
plot(phi_plot,V_conv,'-',phi,Vphi,'o');

figure;
plot(phi_plot,V_svd,'-',phi,Vphi,'o');



    