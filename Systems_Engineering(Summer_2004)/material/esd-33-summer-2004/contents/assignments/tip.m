function [effector]=tip(a1,a2,Z,ez1,ez2,dz3,ex3,ey3,xp2)


% This function simply carries out the matrix multiplications for any
% point in the sample space.  The function takes as arguments the 
% commanded angles of the robot arm (a1 and a2 are theta 1 and theta2),
% the Z position comanded for the linear slide, and all 6 errors.
% You must send the function a SINGLE scalar value for each argument.  Thus
% to do Monte Carlo simulation, callthis function from inside a "for" loop.

M1=[1 0 0 0;
    0 1 0 0;
    0 0 1 1000;
    0 0 0 1];

M2=[cos(a1+ez1) -sin(a1) 0 0;
    sin(a1) cos(a1+ez1) 0 0;
    0 0 1 0;
    0 0 0 1];

M3=[1 0 0 500;
    0 1 -xp2 0;
    0 xp2 1 60;
    0 0 0 1];

M4=[cos(a2+ez2) -sin(a2) 0 0;
    sin(a2) cos(a2+ez2) 0 0;
    0 0 1 0;
    0 0 0 1];

M5=[1 0 0 400;
    0 1 0 0;
    0 0 1 0;
    0 0 0 1];

M6=[1 0 ey3 0;
    0 1 -ex3 0;
    -ey3 ex3 1 -Z-dz3;
    0 0 0 1];

effector=M1*M2*M3*M4*M5*M6*[0; 0; -300; 1];



    