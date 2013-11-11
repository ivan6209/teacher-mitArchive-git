function y=ps5p2_stage2_zero(theta2,tildez);

% This function is the standard Morris-Shin equation to
% solve for the thetastar threshold

global ALPHAX ALPHAZ ALPHATILDEZ B  C X1STAR SELECT;

g=sqrt(1+(ALPHATILDEZ/ALPHAX))*stdn_inv(1-(C/B));
G=(ALPHATILDEZ/sqrt(ALPHAX))*(tildez-theta2)+stdn_inv(theta2);
y=G-g;

