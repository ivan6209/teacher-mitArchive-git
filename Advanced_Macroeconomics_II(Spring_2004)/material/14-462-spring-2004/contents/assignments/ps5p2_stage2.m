function [theta2,x2]=ps5p2_stage2(tildez);

% this function computes the roots of the function ps5p2_stage2_zero,
% using the knowledge we have about the shape of that function

global ALPHAX ALPHAZ ALPHA BETA DELTA ALPHATILDEZ B C X1STAR SELECT OPTIONS...
   THETA2LOWER THETA2UPPER THETA1STAR ZUNDERBAR ZUPPERBAR;

% we know that the function goes to minus infinity as theta2 goes to 0,
% so we can find theta2lower at which the function is negative
% we also know that the function goes to plus infinity as theta2 goes to1,
% so we can find theta2upper at which the function is positive

theta2lower=find_bound_converge('ps5p2_stage2_zero','right',-1,0.1,1,0,tildez);
theta2upper=find_bound_converge('ps5p2_stage2_zero','left',1,0.1,1,1,tildez);
if (tildez<=ZUNDERBAR)|(tildez>=ZUPPERBAR) % this is the case of uniquenesss
   % if it to close to the boundaries, set theta2=1 or theta2=0 respectively,
   % otherwise compute it using fzero
   if isinf(ps5p2_stage2_zero(theta2upper,tildez))
      theta2=1;
   elseif isinf(ps5p2_stage2_zero(theta2lower,tildez))
      theta2=0;
   else
      theta2=fzero('ps5p2_stage2_zero',[theta2lower theta2upper],OPTIONS,tildez); 
   end
   % next check whether it is indeed an equilibrium, if not replace it
   % with what is the equilibrium
   theta2=max(theta2,THETA1STAR);
   if theta2>THETA1STAR
      x2=ps5p2_X(theta2);
   else
      theta2=THETA1STAR;
      x2=ps5p2_Xbinding(theta2,tildez);
   end
else % this is the case of potential multiplicity
   [theta2max,maxvalue]=fmaxbndn('ps5p2_stage2_zero',theta2lower,0.5,1,OPTIONS,[],tildez);
   [theta2min,minvalue]=fminbndn('ps5p2_stage2_zero',0.5,theta2upper,1,OPTIONS,[],tildez);
   if isinf(ps5p2_stage2_zero(theta2lower,tildez))
      theta2left=0;
   else
      theta2left=fzero('ps5p2_stage2_zero',[theta2lower theta2max],OPTIONS,tildez); 
   end
   if isinf(ps5p2_stage2_zero(theta2upper,tildez))
      theta2right=1;
   else
      theta2right=fzero('ps5p2_stage2_zero',[theta2min theta2upper],OPTIONS,tildez); 
   end
   if SELECT==0 % this selects the lower equilibrium
      if (theta2left<THETA1STAR)&(ps5p2_stage2_zero(THETA1STAR,tildez)<0)
         theta2=theta2right;
         x2=ps5p2_X(theta2);
      else 
         if theta2left>THETA1STAR
            theta2=theta2left;
            x2=ps5p2_X(theta2);
         else
            theta2=THETA1STAR;
            x2=ps5p2_Xbinding(theta2,tildez);
         end            
      end
   else % this selects the higher equilibrium
      if theta2right>THETA1STAR
         theta2=theta2right;
         x2=ps5p2_X(theta2);
      else
         theta2=THETA1STAR;
         x2=ps5p2_Xbinding(theta2,tildez);
      end         
   end        
end

      