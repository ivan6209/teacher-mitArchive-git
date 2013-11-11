function y=find_bound_converge(f,d,signum,firststep,i,varargin);

% FIND_BOUND_CONVERGE(f,d,signum,firststep,i,varargin);
% f is a string that contains the name of the function 
% d is a string and must be either 'right' or 'left'
% if d='right', then the function will be evaluated at values that
% approach the limit value from the right (values of argument becoming smaller)
% if d='left', then the function will be evaluated at values that
% approach the limit value from the left(values of argument becoming larger)
% signum can take the values -1,0,1 and NaN, and the routine stops
% once the function takes a value with sign equal to signum
% firststep is the amount added/subtracted in the first iteration,
% the value added/subtracted at iteration n being 0.5^(n-1)*firststep
% the function f is allowed to have more than one argument, and
% i is the position of the argument for which convergence occurs
% varargin gives the limit values for all the arguments of f

if strcmpi(d,'right')
   x=firststep;
elseif strcmpi(d,'left')
   x=-firststep;
else
   error('Direction must be either right or left!');
end
found_boundary=0;
n=length(varargin);
start_value=varargin{i};
if isnan(signum)
  while (found_boundary==0)
      x=0.5*x;
      varargin{i}=start_value+x;
      fvalue=feval(f,varargin{1:n});
      if isnan(fvalue)  
         found_boundary=1;
         y=start_value+x;
      end
   end 
else
   while (found_boundary==0)
      x=0.5*x;
      varargin{i}=start_value+x;
      fvalue=feval(f,varargin{1:n});
      if (sign(fvalue)==signum)   
         found_boundary=1;
         y=start_value+x;
      end
   end
end