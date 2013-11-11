function zunderbar=ps5p2_zunderbar;

global ALPHAX ALPHAZ ALPHATILDEZ B  C X1STAR SELECT OPTIONS;

% we know that the function goes to minus infinity as theta2 goes to 0,
% so we can find theta2lower at which the function is negative
% we also know that the function goes to plus infinity as theta2 goes to1,
% so we can find theta2upper at which the function is positive
zlower=find_bound_diverge('ps5p2_zunderbar_zero','left',-1,1,1,0);
zupper=find_bound_diverge('ps5p2_zunderbar_zero','right',1,1,1,1);
zunderbar=fzero('ps5p2_zunderbar_zero',[zlower zupper],OPTIONS);


%[theta2min,minvalue]=fminbndn('ps5p2_stage2_zero',0.5,theta2upper,1,OPTIONS,[],tildez);

      