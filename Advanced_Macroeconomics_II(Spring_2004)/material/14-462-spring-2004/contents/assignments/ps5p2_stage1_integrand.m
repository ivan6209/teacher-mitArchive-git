function integrand=ps5p2_stage1_integrand(tildez);


global ALPHAX ALPHAZ ALPHA BETA DELTA ALPHATILDEZ B C X1STAR SELECT OPTIONS...
   ZUNDERBAR ZUPPERBAR;

for i=1:length(tildez);
   [theta2,x2]=ps5p2_stage2(tildez(i));
   density=sqrt( (1+ALPHAZ)/(ALPHAX*ALPHAZ*2*pi))*exp( -0.5 *((1+ALPHAZ)/(ALPHAZ*ALPHAX))*(tildez(i)-X1STAR)^2);
   probability=1-stdn_cdf(sqrt(ALPHA)*(DELTA*X1STAR+(1-DELTA)*tildez(i)-theta2));
   indicator=(X1STAR<=x2);
   integrand(i)=( (1+BETA)-BETA*indicator)*(B*probability-C)*density;
end

