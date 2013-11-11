function xstar=ps5p1_xstar(z);

global GAMMA ALPHAX ALPHAZ ALPHA DELTA C OPTIONS SELECT;

[xmax,maxvalue]=fmaxbndn('ps5p1_integral',-100,2,1,OPTIONS,[],z);
[xmin,minvalue]=fminbndn('ps5p1_integral',2,100,1,OPTIONS,[],z);

if (maxvalue<0)|(minvalue>0)
   xstar=fzero('ps5p1_integral',[-100 100],OPTIONS,z);
else
   xstarL=fzero('ps5p1_integral',[-100 xmax],OPTIONS,z);
   xstarH=fzero('ps5p1_integral',[xmin 100],OPTIONS,z);
   if SELECT==-1
      xstar=xstarL;
   elseif SELECT==1
      xstar=xstarH;
   end
end
   