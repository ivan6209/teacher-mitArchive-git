% this function evaulates the value of 1/R_HH^6 based on the geometry.
% Essentially it is the magnitude of the vector connecting the H atoms.

function invR6=RHH_6(q)
% O1 = (0,0,0)
% O2 = (xO2,0,0)
% H1 = (xH1,yH1,0);
% xO2=q(1);  %all x,y,z in Angstroms
% xH1=q(2); yH1=q(3);
% xH2=q(4); yH2=q(5); zH2=q(6);

RHH=norm([q(4)-q(2);q(5)-q(3);q(6)]);
R6=RHH.^6;
invR6=1./R6;