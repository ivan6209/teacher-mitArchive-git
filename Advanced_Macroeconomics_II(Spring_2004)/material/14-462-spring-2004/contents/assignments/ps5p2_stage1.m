function integral=ps5p2_stage1;


global ALPHAX ALPHAZ ALPHA BETA DELTA ALPHATILDEZ B C X1STAR SELECT OPTIONS...
   THETA2LOWER THETA2UPPER THETA1STAR Z1STAR ZUNDERBAR ZUPPERBAR;

X1STAR=x1star;
THETA1STAR=ps5p2_Theta(X1STAR);
Z1STAR=ps5p2_z1star;
lower=x1star-sqrt( ALPHAX*ALPHAZ/(1+ALPHAZ))*stdn_inv(1-1e-3/2);
upper=x1star+sqrt( ALPHAX*ALPHAZ/(1+ALPHAZ))*stdn_inv(1-1e-3/2);
ZBOUNDS=sort([ZUNDERBAR Z1STAR ZUPPERBAR]);
if SELECT==0
   integral1=quad8('ps5p2_stage1_integrand',lower,ZBOUNDS(1)-1e-5);    
   integral2=quad8('ps5p2_stage1_integrand',ZBOUNDS(1)+1e-5,ZBOUNDS(2)-1e-5);
   integral3=quad8('ps5p2_stage1_integrand',ZBOUNDS(2)+1e-5,ZBOUNDS(3)-1e-5); 
   integral4=quad8('ps5p2_stage1_integrand',ZBOUNDS(3)+1e-5,upper);
end
integral=integral1+integral2+integral3+integral4;

