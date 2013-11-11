function x2=ps5p2_Xbinding(theta2,tildez);


global ALPHAX ALPHAZ ALPHA DELTA ALPHATILDEZ B  C X1STAR SELECT OPTIONS;

theta1star=ps5p2_Theta(X1STAR);
x2=(1/DELTA)*( (1/sqrt(ALPHA))*stdn_inv(1-(C/B))-(1-DELTA)*tildez+theta1star);




