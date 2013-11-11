function theta2=ps5p2_Theta(x2);

% This function is the standard Morris-Shin equation to
% solve for the thetastar threshold

global ALPHAX ALPHAZ ALPHATILDEZ B  C X1STAR SELECT OPTIONS;

theta2lower=find_bound_converge('ps5p2_Theta_zero','right',-1,0.1,1,0,x2);
theta2upper=find_bound_converge('ps5p2_Theta_zero','left',1,0.1,1,1,x2);
theta2=fzero('ps5p2_Theta_zero',[theta2lower theta2upper],OPTIONS,x2);


