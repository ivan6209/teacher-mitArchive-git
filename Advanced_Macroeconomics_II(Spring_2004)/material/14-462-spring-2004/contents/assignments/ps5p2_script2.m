global ALPHAX ALPHAZ ALPHA BETA DELTA ALPHATILDEZ B C X1STAR SELECT OPTIONS...
   THETA2LOWER THETA2UPPER THETA1STAR Z1STAR ZUNDERBAR ZUPPERBAR;

OPTIONS=optimset('Display','off');
ALPHAX=1;
ALPHAZ=3;
ALPHATILDEZ=ALPHAZ*ALPHAX;
ALPHA=ALPHAX*(1+ALPHAZ);
BETA=0.8;
DELTA=1/(1+ALPHAZ);
B=1;
C=0.5;
X1STAR=0;

if ALPHAZ*sqrt(ALPHAX)<=sqrt(2*pi)
   ZUNDERBAR=0.5;
   ZUPPERBAR=0.5;
else
   ZUNDERBAR=ps5p2_zunderbar;
   ZUPPERBAR=ps5p2_zupperbar;
end

SELECT=0;
x1star=fzero('ps5p2_stage1_integral',[0 0.5]);
X1STAR=x1star;
THETA1STAR=ps5p2_Theta(X1STAR);

figure(6);
clf;
hold on;
fplot('ps5p2_stage2_x2',[ZUNDERBAR-0.01 ZUPPERBAR+0.01]);

xlabel('z');
ylabel('x_2*(z)');
XLIM=get(gca,'Xlim');
plot(XLIM,[X1STAR X1STAR],'--');



BETA=0.5;
x1star=fzero('ps5p2_stage1_integral',[0 0.6]);
X1STAR=x1star;
THETA1STAR=ps5p2_Theta(X1STAR);


fplot('ps5p2_stage2_x2',[ZUNDERBAR-0.01 ZUPPERBAR+0.01],':');

YLIM=get(gca,'Ylim');
plot([ZUNDERBAR ZUNDERBAR],YLIM,'--');
plot([ZUPPERBAR ZUPPERBAR],YLIM,'--');
XLIM=get(gca,'Xlim');
plot(XLIM,[X1STAR X1STAR],'-.');

filename=['c:\teaching\14.462 Spring 2004\problem sets\ps5_fig7'];
orient portrait;
print('-depsc',filename);
delete_student([filename '.eps']);

BETA=0.8;
SELECT=0;
x1star=fzero('ps5p2_stage1_integral',[0 0.5]);
X1STAR=x1star;
THETA1STAR=ps5p2_Theta(X1STAR);

figure(7);
clf;
hold on;
fplot('ps5p2_stage2_xp',[ZUNDERBAR-0.01 ZUPPERBAR+0.01]);

xlabel('z');
ylabel('x_p*(z)');
XLIM=get(gca,'Xlim');
plot(XLIM,[X1STAR X1STAR],'--');



BETA=0.5;
x1star=fzero('ps5p2_stage1_integral',[0 0.6]);
X1STAR=x1star;
THETA1STAR=ps5p2_Theta(X1STAR);

fplot('ps5p2_stage2_xp',[ZUNDERBAR-0.01 ZUPPERBAR+0.01],':');

YLIM=get(gca,'Ylim');
plot([ZUNDERBAR ZUNDERBAR],YLIM,'--');
plot([ZUPPERBAR ZUPPERBAR],YLIM,'--');
XLIM=get(gca,'Xlim');
plot(XLIM,[X1STAR X1STAR],'-.');

filename=['c:\teaching\14.462 Spring 2004\problem sets\ps5_fig8'];
orient portrait;
print('-depsc',filename);
delete_student([filename '.eps']);






