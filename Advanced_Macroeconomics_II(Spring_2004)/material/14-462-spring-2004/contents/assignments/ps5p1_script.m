global GAMMA ALPHAX ALPHAZ ALPHA DELTA C OPTIONS SELECT;

% This script file generates the output for the solution of problem 1 in problem set 5
% for course 14.462 in Spring 2004

% set options to supress output of optimization routines
OPTIONS=optimset('Display','off');

% parameters that remain the same throughout the exercise

GAMMA=0.8;
C=2;

% calculations from part 1

THETALOWER=log(C/2);
THETAUPPER=log(C);

% these will be the bounds in the plots, a bit to the left from THETALOWER
% and a bit to the right of THETAUPPER

ZLOWER=THETALOWER-0.05; 
ZUPPER=THETAUPPER+0.05;

% which graphs should be created in this run? 
GRAPH1=0;
GRAPH2=1;

if GRAPH1 % graph 1 starts here
   
ALPHAX=10;
ALPHAZ=1;
ALPHA=ALPHAX+ALPHAZ;
DELTA=ALPHAX/ALPHA;

figure(1);
clf;
hold on;
SELECT=-1;
fplot('ps5p1_xstar',[ZLOWER ZUPPER]);
SELECT=1;
fplot('ps5p1_xstar',[ZLOWER ZUPPER]);
xlabel('z');
ylabel('x*(z)');

YLIM=get(gca,'Ylim');
plot([THETALOWER THETALOWER],YLIM,'--');
plot([THETAUPPER THETAUPPER],YLIM,'--');
text(THETAUPPER,YLIM(1)-0.07*(YLIM(2)-YLIM(1)),'\theta');
text(THETAUPPER,YLIM(1)-0.04*(YLIM(2)-YLIM(1)),'\_');
text(THETALOWER,YLIM(1)-0.07*(YLIM(2)-YLIM(1)),'\theta');
text(THETALOWER,YLIM(1)-0.07*(YLIM(2)-YLIM(1)),'\_');

filename=['c:\teaching\14.462 Spring 2004\problem sets\ps5_fig1'];
orient portrait;
print('-depsc',filename);
delete_student([filename '.eps']);
   
end % graph 1 stops here   
   
if GRAPH2 % graph 2 starts here
   
% parameter configuration for part 3

ALPHAX=1;
ALPHAZ=10;
ALPHA=ALPHAX+ALPHAZ;
DELTA=ALPHAX/ALPHA;

figure(2);
clf;
hold on;
SELECT=-1;
fplot('ps5p1_xstar',[ZLOWER ZUPPER]);
SELECT=1;
fplot('ps5p1_xstar',[ZLOWER ZUPPER]);
xlabel('z');
ylabel('x*(z)');

ALPHAX=1;
ALPHAZ=100;
ALPHA=ALPHAX+ALPHAZ;
DELTA=ALPHAX/ALPHA;

SELECT=-1;
fplot('ps5p1_xstar',[ZLOWER ZUPPER],':');
SELECT=1;
fplot('ps5p1_xstar',[ZLOWER ZUPPER],':');

YLIM=get(gca,'Ylim');
plot([THETALOWER THETALOWER],YLIM,'--');
plot([THETAUPPER THETAUPPER],YLIM,'--');
text(THETAUPPER,YLIM(1)-0.07*(YLIM(2)-YLIM(1)),'\theta');
text(THETAUPPER,YLIM(1)-0.04*(YLIM(2)-YLIM(1)),'\_');
text(THETALOWER,YLIM(1)-0.07*(YLIM(2)-YLIM(1)),'\theta');
text(THETALOWER,YLIM(1)-0.07*(YLIM(2)-YLIM(1)),'\_');

filename=['c:\teaching\14.462 Spring 2004\problem sets\ps5_fig2'];
orient portrait;
print('-depsc',filename);
delete_student([filename '.eps']);

end % graph 2 stops here


