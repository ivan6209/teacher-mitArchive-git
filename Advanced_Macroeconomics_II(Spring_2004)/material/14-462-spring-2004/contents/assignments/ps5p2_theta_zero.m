function y=ps5p2_Theta_zero(theta2,x2);

% This function is the standard Morris-Shin equation to
% solve for the thetastar threshold

global ALPHAX ALPHAZ ALPHATILDEZ B  C X1STAR SELECT;

y=theta2+(1/sqrt(ALPHAX))*stdn_inv(theta2)-x2;

