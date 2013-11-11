function integral=ps5p1_integral(xstar,z);

global GAMMA ALPHAX ALPHAZ ALPHA DELTA C;

lower=DELTA*xstar+(1-DELTA)*z-10/sqrt(ALPHA);
upper=DELTA*xstar+(1-DELTA)*z+10/sqrt(ALPHA);
integral=quad8('ps5p1_integrand',lower,upper,1e-5,[],z,xstar)-C;         