function varargout = APscr(name,varargin)
%APSCR HH scripting functions.
%  ---------------------------------------
%  NAME    DESCRIPTION
%  'set'   set a parameter's value
%  'get'   get a parameter's current value
%  'start' start simulation
%  'save'  save data
%  'help'  assistance with scripting
%  'demo'  demonstrations on scripting
%  ---------------------------------------
%  Type APscr('help',NAME) for help on any of these named functions.

%Copyright (c) 1995-1998 by T.S. Bhatnagar 

ni = nargin;
if ni < 1, help('APscr'); return; end
switch name
case 'start' %start simulation
  APcntrl('start'); return;

case 'save' %save data
  %in{1}='parameters'|'stimulus'|'simulation', in{2}=pathname, in{3}=filename
  %out{1}=0|1 (success)
  out1 = 0; %default is to fail
  if ni ~= 4
        HelpSave;
  else
        switch varargin{1}
        case 'parameters', fcn = 'APparams';
        case 'stimulus', fcn = 'APstim';
        case 'simulation', fcn = 'APcntrl';
        otherwise, HelpSave; return;
        end
        varargout{1} = feval(fcn,'save',varargin{2},varargin{3});
  end
  return;

case 'demo' %demonstration on scripting
  echo APdemo1 on
  APdemo1;
  echo APdemo1 off
  return;

case 'set' %set parameter value
  %in{1:(end-1)}=Parameter specifiers, in{end}=parameter value
  %out{1} = new parameter value
  varargout{1} = [];
  %The first N entries should be in the same order as in the Parameters figure.
  pname={'G_Na_bar','G_K_bar','G_L_bar','K_m','V_alpha_m','V_beta_m', ...
        'K_h','V_alpha_h','V_beta_h','K_n','V_alpha_n','V_beta_n', ...
	'C_m','V_L','T_C','c_Na_o','c_Na_i','c_K_o','c_K_i', ...
        'c_Ca_o','c_Ca_i','l','a','rho_i','r_o', ...
	 'dur','stimulus','numerics'};
  str=str2mat('The following parameters can be set using APscr(''set''):', ...
          sprintf('%-15s %-15s %-15s %-15s\n',pname{:}));
  if ni == 1, ShowString(str); return; end

  indx = find(strcmpi(pname,varargin{1}));
  if isempty(indx)
        ShowString(str2mat(sprintf('%s: unknown parameter.',varargin{1}),'',str));
        return;
  end
  varargin{1} = pname{indx};

  switch varargin{1}
  case 'dur' %change the duration of the simulation
    if ni > 2
      varargout{1} = APcntrl('dur',varargin{2}); end
    helpstr = str2mat('Allowed calls are:', ...
      '  hhscr(''set'',''dur'',NewValue)');
  case 'stimulus' %change a stimulus parameter
        if ni < 3, varargin{2}=''; end, if ni < 4, varargin{3}=''; end
        [varargout{1},helpstr] = ChangeStimulus(varargin{2:end});
  case 'numerics' %change a numerics parameter
        if ni < 3, varargin{2}=''; end
        [varargout{1},helpstr] = ChangeNumerics(varargin{2:end});
  otherwise %change a model parameter
        if ni > 2, varargout{1} = APparams('change',indx,varargin{2}); end
  end
  if isempty(varargout{1}), ShowString(helpstr); end
  return;

case 'get' %get a variable's current value
  %in{:}=variable specifiers
  %out{1}=variable value
  varargout{1} = [];
  %The first N entries should be in the same order as in the Parameters figure.
  pname={'G_Na_bar','G_K_bar','G_L_bar','K_m','V_alpha_m','V_beta_m', ...
        'K_h','V_alpha_h','V_beta_h','K_n','V_alpha_n','V_beta_n', ...
	'C_m','V_L','T_C','c_Na_o','c_Na_i','c_K_o','c_K_i', ...
        'c_Ca_o','c_Ca_i','l','a','rho_i','r_o', ...
        'V_Na','V_K','deltaV_Ca','K_T','r_i' ...
	 'stimulus','numerics' ...
        't','V_{ m}','J_{ m}','h','m','n', ...
        'G_{ Na}','G_{ K}','G_{ L}','G_{ m}','J_{ m}','J_{ m} (comp)', ...
        'J_{ Na}','J_{ K}','J_{ L}','J_{ C}','J_{ ion}', ...
        '\alpha_{ m}','\beta_{ m}','\tau_{ m}', ...
        '\alpha_{ h}','\beta_{ h}','\tau_{ h}', ...
        '\alpha_{ n}','\beta_{ n}','\tau_{ n}'};
  str=str2mat('The following parameters can be retrieved using APscr(''get''):', ...
        sprintf('%-15s %-15s %-15s %-15s\n',pname{:}));
  if ni < 2, ShowString(str); return; end

  indx = find(strcmpi(pname,varargin{1}));
  if isempty(indx)
        ShowString(str2mat(sprintf('%s: unknown parameter.',varargin{1}),'',str));
        return;
  end
  if indx < 31 %straight parameters
        p = APparams('parameters');     varargout{1} = p(indx);
  else
        varargin{1} = pname{indx};
        switch varargin{1}
        case 'stimulus'
          [varargout{1},helpstr] = GetStimulus(varargin{2:end});
        case 'numerics'
          if ni < 3, varargin{2}=''; end
          [varargout{1},helpstr] = GetNumerics(varargin{2:end});
        otherwise %get simulation data
          distance = varargin{2};
          time = varargin{3};
          varargout{1} = APcntrl('get',varargin{1},{distance;time});
        end
        if isempty(varargout{1}), ShowString(helpstr); end
  end
  return;

case 'help' %help on one of the scripting functions
  if ni < 2, varargin{1} = 'help'; end
  str = '';
  pname = {'help','demo','start','set','get'};
  indx = find(strcmp(pname,varargin{1})); if isempty(indx), indx = 0; end
  switch indx
  case 1 %how to use script
        help('APscr');
  case 2
        str = str2mat('APscr(''demo'') runs a demonstration script.', ...
          '  The script commands will appear in the console as they are executed.');
  case 3
        str = str2mat('APscr(''start'') starts the simulation with the', ...
          '  current parameters, stimulus, and configuration.');
  case 4
        str = str2mat('APscr(''set'') lists all parameters that can be set', ...
          'APscr(''set'',ParName,ParVal) sets parameter named ParName to ParVal', ...
          'APscr(''set'',ParName) may offer allowed values for ParName', ...
          'APscr(''set'',''stimulus'') will list stimulus parameters that can be modified', ...
          'APscr(''set'',''numerics'') will list numerics that can be modified');
  case 5
        str=str2mat('APscr(''get'') lists all variables that can be retrieved', ...
          'APscr(''get'',VarName) returns the current value of the named variable.', ...
          'APscr(''get'',''stimulus'') returns the stimulus parameters that can be retrieved', ...
          'APscr(''get'',''numerics'') returns the numerics that can be retrieved');
  otherwise
        str = str2mat(sprintf('%s: unrecognized request.',varargin{1}), ...
          '  Requests should be one of these:', ...
          ['  ' sprintf('%-10s\n',pname{:})]);
  end
  if ~isempty(str), ShowString(str); end
  return;
end


function HelpSave
%Help on saving data
str = str2mat('APscr(''save'',''parameters'',PathName,FileName)', ...
  '  will save the independent parameters to a file', ...
  '  specified by FileName and PathName.', ...
  'APscr(''save'',''stimulus'',PathName,FileName)', ...
  '  will save the pulsatile stimulus parameters to a file', ...
  '  specified by FileName and PathName.', ...
  'APscr(''save'',''simulation'',PathName,FileName)', ...
  '  will save all relevant simulation data (parameters, variables)', ...
  '  to a file specified by FileName and PathName.');
ShowString(str);
return;


function [newval,helpstr] = ChangeStimulus(varargin)
%Handle stimulus requests
ni = nargin; newval = []; helpstr = 'Allowed calls are:';
pname = {'pulse1','pulse2','holding'};
indx = find(strcmpi(pname,varargin{1})); if isempty(indx), indx = 0; end
switch indx
case {1,2}
  pname = {'start','duration','amplitude','slope','timeconstant'};
  pindx = find(strcmpi(pname,varargin{2}));
  if ~isempty(pindx) & ni == 3
        newval = APstim('edit',indx,pindx,varargin{3});
        helpstr = '';
  else
        formatstr = sprintf('  APscr(''set'',''stimulus'',''pulse%d'',''%%s'',NewValue)',indx);
        for k=1:length(pname)
          helpstr = str2mat(helpstr,sprintf(formatstr,pname{k}));
        end
  end
case 3
  if ni == 2
        helpstr = ''; newval = APstim('holding',varargin{2});
  else
        helpstr = str2mat(helpstr,'  APscr(''set'',''stimulus'',''holding'',NewValue)');
  end
otherwise
  for k=1:length(pname)
        helpstr = str2mat(helpstr,sprintf('  APscr(''set'',''stimulus'',''%s'',NewValue);',pname{k}));
  end
  newval = [];
end
return;


function [newval,helpstr] = ChangeNumerics(varargin)
%Handle numerics requests
helpstr = 'Allowed calls are:'; newval = [];
pname = {'algo','dt','dx'};
indx = find(strcmpi(pname,varargin{1})); if isempty(indx), indx = 0; end
switch indx
case 1
  pname = {'Forward Euler','Backward Euler','Crank-Nicolson','Staggered C-N'};
  helpstr = str2mat(helpstr,'  hhscr(''set'',''numerics'',''algorithm'',Algo);', ...
        '    where Algo can be one of these:', ...
        ['    ' sprintf('%-15s',pname{:})]);
  indx = strcmpi(pname,varargin{2});
  if ~isempty(indx), newval = APnum('algo',pname{indx}); end
case {2,3}
  if ni == 2
    helpstr = ''; newval = APnum(varargin{1},varargin{2});
  else
    helpstr = str2mat(helpstr,'  APscr(''set'',''numerics'',''%s'',NewValue)');
  end 
otherwise, %display help string
  for k=1:length(pname)
        helpstr = str2mat(helpstr,sprintf('  APscr(''set'',''numerics'',''%s'',NewValue);',pname{k}));
  end
  newval = [];
end
return;


function [curval,helpstr] = GetStimulus(name,subname)
%Handle stimulus requests
ni = nargin; helpstr = '';
pname = {'pulse1','pulse2','holding'};
if ~ni, indx = 0;
else 
  indx = find(strcmpi(pname,name));
  if isempty(indx), indx = 0; end
end

switch indx
case {1,2}
  pname = {'start','duration','amplitude','slope','timeconstant'};
  if ni < 2, pindx = [];
  else, pindx = find(strcmpi(pname,subname));
  end
  if ~isempty(pindx)
    s = APstim('stimulus');
    curval = s.pulse{indx,pindx};
  else
    helpstr = 'Allowed calls are:';
    for k=1:length(pname)
      helpstr = str2mat(helpstr,sprintf('  APscr(''get'',''stimulus'',''%s'',''%s'');',name,pname{k}));
    end
    curval = [];
  end
case 3, s = APstim('stimulus'); curval = s.holding;
otherwise
  helpstr = 'Allowed calls are:';
  for k=1:length(pname)
    helpstr = str2mat(helpstr,sprintf('  APscr(''get'',''stimulus'',''%s'');',pname{k}));
  end
  curval = [];
end
return;


function [curval,helpstr] = GetNumerics(varargin)
%Handle numerics requests
helpstr=''; pname = {'algo','dt','dx'};
indx = find(strcmpi(pname,varargin{1})); if isempty(indx), indx = 0; end
switch indx
case 1, curval = APnum('algo');
case 2, n = APnum('numerics'); curval = n.dt;
case 3, n = APnum('numerics'); curval = n.dx;
otherwise, %display help string
  helpstr = 'Allowed calls are:';
  for k=1:length(pname)
        helpstr = str2mat(helpstr,sprintf('  APscr(''get'',''numerics'',''%s'');',pname{k}));
  end
  curval = [];
end
return;


function ShowString(str)
%Handle information display
disp(str);
return;
