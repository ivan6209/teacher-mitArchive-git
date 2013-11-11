% this program solves an Income Fluctuation Problem
% requires obj.m function which is the RHS of the Bellman
% equation as a function of c=consumption and x=cash in hand

global sigma beta yl yh R ppv ppf s1 p1

% possible shocks are in s1 and probability in p1
s1  = [.5 1.5];
p1  = [.5;.5 ];
% other specification to experiment with: (taken from L-S book)
%s1 = [0.3012,0.4493,0.6703,1.0000,1.4918,2.2255,3.3201];
%s2 = [0.0410,0.1769,0.4245,0.8757,1.6978,3.1958,5.9253];
%p1 = [0.0063,0.0608,0.2417,0.3823,0.2417,0.0608,0.0063]';
yl=min(s1); yh=max(s1);

% parameters
% make sure beta*(1+r)<1 !!!
sigma=.5; w = 1; ymean=s1*p1;
beta=.95;  delta=1/beta-1
r=.02
R=1+r;
xgrid=100;

% grid for x -- exludes zero to avoid utility==-infinity -- lower bound is loweste income realization
% || note: make sure that xhigh is high enough so that assets contained in our grid interval!
% if you iterate and it seems like this is not the case adjust xhigh accordingly
% likewise, don't make it too large because it is wasteful ||
epsilon=1e-3; xhigh= yh*5; xlow = yl;
x=(xlow : (xhigh - xlow)/(xgrid-1) :xhigh)';

% initial "guess"(es)
c       = min((r/1+r)*x + yl/(1+r),x);
v_mean  = 1/(1-beta)*(r/R*x + ymean).^(1-sigma)/(1-sigma);
v_aut   = (r/R*x).^(1-sigma)/(1-sigma) + beta/(1-beta)*(r/R*x*ones(1,length(s1)) + ones(length(x),1)*s1).^(1-sigma)*p1/(1-sigma);
% use this guess...
v       = v_mean;
% ... in spline form (for interpolating between grid points)
ppv=spline(x,v);

% iterate until convergence
iter=0; crit=1; c_new =c; v_new=v;
while crit >1e-10
    
    % compute for each point on the grid for x the optimal c
    for i=1:xgrid
        
        % perform the minimization -- obj.m is a function for the negative of the RHS of the bellman
        % the optimization is performed over c between 0 and x(i); the last argument is to pass the 
        % current cash available as a parameter, so that obj is looked at as a function of c only by
        % the optimizer
        if i>1; c_low=c(i-1) ;else; c_low=0;end; %incorporate that we know consumption increases in x
        c_low=0;
        [c_new(i) bla]=fminbnd('obj', c_low , x(i) , [] ,x(i));
        v_new(i) = -bla; % note: obj is the negative of the true objective function
    end
    
    % update interation housekeeping (criterion and iteration number)
    v_equiv     = ((1-sigma)*(1-beta)*v).^(1/(1-sigma));
    v_new_equiv = ((1-sigma)*(1-beta)*v_new).^(1/(1-sigma));
    [crit bla1]= max(abs( v_equiv - v_new_equiv ));
    [crit_c bla2]= max(abs( (c - c_new)./c )); crit_c= 100*(c_new(bla2) - c(bla2))/c(bla2);
    crit_percent= [v_new_equiv(bla1) - v_equiv(bla1)]*100/ymean;
    iter=iter+1;
    disp([crit_percent , crit_c*100, iter]) ; % display iteration statistics in percentage + or -
    disp([x(bla1) , x(bla2)])  ; %displays where the action is on x-grid

    v=v_new; c=c_new; ppv=spline(x,v); % updates information after iteration
    
    % iterate on c(x) policy if its quite stable (using Howard iteration technique)
    % make sure this does speed up convergence and not make convergence problematic
    % removing this part if necessary
    if abs(crit_c*100) < 1e-4
        disp('howard iteration k=100')
        for k=1:100;
            v=-obj(c,x);  
            ppv=spline(x,v);
        end
    end
    
end

ppc = spline(x,c); % splines policy function for use in simulation.m

% creates a plot of 45 degree line, a' x_high x_low and c
plot(x,[x x-c R*(x-c)+yh R*(x-c)+yl c]); grid