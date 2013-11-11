function [Vtot_opt,Vtot_pJ] = V(q)
% computes V for MonteCarlo problem.  the first output is used in the
% minimization of the potential and is V in pJ times 1e12.  The second is
% what is used in the MC steps and is return in picoJoules.

% O1 = (0,0,0)
% O2 = (xO2,0,0)
% H1 = (xH1,yH1,0);

xO2=q(1);  %all x,y,z in Angstroms
xH1=q(2); yH1=q(3);
xH2=q(4); yH2=q(5); zH2=q(6);

% calculate the variables used in the potentials.  Included is converting
% cartesian coordinate into angles
ROO=abs(xO2);
ROH1=norm([xH1; yH1]);
ROH2=norm([xH2-xO2; yH2; zH2]);

Rlong1=norm([xH1-xO2; yH1]);
HOO=acos(-0.5*(Rlong1*Rlong1-(ROH1*ROH1+ROO*ROO))./(ROH1*ROO));

Rlong2=norm([xH2; yH2; zH2]);
OOH=acos(-0.5*(Rlong2*Rlong2-(ROH2*ROH2+ROO*ROO))./(ROH2*ROO));

cosphi=yH1*yH2/(abs(yH1)*norm([yH2; zH2]));

kOO=3e-6;  % [=]picoJoule/Angstrom^2
LO=1.6;  % [=] Angstrom

% stretching potential... also utilizes the Morse potential for OH bonds
Vstretch=Vmorse(ROH1)+Vmorse(ROH2)+0.5*kOO*(ROO-LO).^2;

% angular potential function
ktheta=1e-6;%[=]picoJoule/radian^2
theta0=1.8; %[=]radian
Vbend=0.5*ktheta*(((HOO-theta0).^2)+((OOH-theta0).^2));

% dihedral potential function
Kphi=80e3/6.022e11; % picoJoule (per molecule)
Vphi=Kphi*sin(0.5*HOO)*sin(0.5*OOH)*(cosphi-cos(1.7)).^2;

% Total potential is the sum of all three
Vtot_pJ = Vstretch + Vbend + Vphi;

Vtot_opt = Vtot_pJ*1e12;

%q0 =
%    1.6000
%   -0.2386
%    1.0225
%    1.8386
%   -0.1317
%    1.0140
%V(q0)
%
%ans =
%
%  1.8982e-034