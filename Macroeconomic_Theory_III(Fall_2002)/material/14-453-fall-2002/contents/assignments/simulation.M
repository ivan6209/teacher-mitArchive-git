% create simulation
% you must have the parameters from buffer.m loaded already

% creates cummulative
p1_c(1) = p1(1);
for i=2:length(p1)
    p1_c(i) = p1_c(i-1) + p1(i);
end

% corrects to ensure last number is 1
p1_c(i)=1;

% initial cash in hand and output
xx(1) = 1; yy(1) = 1;

% simulate long series
for t=1:21000
    
    % simluate income shock
    shock = rand;
    index_shock = min(find(p1_c>shock));
    yy(t+1) = s1(index_shock);
    
    % we correct consumption if x is out of our range
    if xx(t) > xhigh
        cc(t) = ppval(ppc,xhigh) + ppval(fnder(ppc),xhigh)*(xx(t)-xhigh); % extrapolate from our consumption function linearly if we are out of our range
    else
        cc(t) = ppval(ppc,xx(t)); % use our consumption function if we are in the range
    end
        
    % compute next period cash-in-hand
    xx(t+1) = R*(xx(t)- cc(t)) + yy(t+1);
end

t=t+1
% we're finished, but just so all series are equally long...
if xx(t) > xhigh
    cc(t) = ppval(ppc,xhigh) + ppval(fnder(ppc),xhigh)*(xx(t)-xhigh); % extrapolate from our consumption function linearly if we are out of our range
else
    cc(t) = ppval(ppc,xx(t)); % use our consumption function if we are in the range
end
