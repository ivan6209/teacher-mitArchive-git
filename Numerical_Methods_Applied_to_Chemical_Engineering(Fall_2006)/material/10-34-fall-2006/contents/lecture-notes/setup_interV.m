function [N,Vphi,phi]=setup_interV
countphi = 0:5;
phi=(pi/3)*countphi';
Vphi=[0; 2.1; 0.5; 8.6; 0.4; 1.8];
N=countphi';    %sets up interpolation: length(N)=length(phi)