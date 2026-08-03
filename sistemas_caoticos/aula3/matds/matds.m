
function varargout = matds(varargin)
% MATDS Application M-file for matds.fig
%    FIG = MATDS launch matds GUI.
%    MATDS('callback_name', ...) invoke the named callback.

% Last Modified by GUIDE v2.0 27-Jan-2003 12:54:54

% DS-system
global DS;

% Calculation constants
global session_time;
global aboutpress;
global WasChanged;
global calculation_progress first_call;


% Windows
global nbrwin;
global session_windows;
global driver_window;

% Parameters
global P;

% Path
global matdspath;

% Trajectory bufer
global TRJ_bufer Time_bufer;
global bufer_i;

% Initialization
  if nargin == 0
     calculation_progress=0;
     WasChanged = 0;
     matdspath.main = pwd;    
     tmpi=findstr(matdspath.main( (length(pwd)-5):length(pwd)),'matds');
     if isempty(tmpi)==1
        fprintf('\n The MATDS-directory must be a current!');
        fprintf('\n The work is impossible, sorry...');
        return
     end;

% Path update

     addpath(matdspath.main);
     matdspath.systems=[matdspath.main filesep 'systems'];
     addpath(matdspath.systems);
     matdspath.gui=[matdspath.main filesep 'gui'];
     addpath(matdspath.gui);
     matdspath.temp=[matdspath.main filesep 'temp'];
     addpath(matdspath.temp);
     matdspath.maths=[matdspath.main filesep 'maths'];
     addpath(matdspath.maths);

     session_time = clock;
     fprintf('         Welcome to dynamical system investigation');

     DS(1).currfile = [matdspath.systems filesep 'lorenz'];

     session_windows.sysdef = [];
     session_windows.editsys = [];
     session_windows.vars = [];
     session_windows.params = [];
     session_windows.intdata = [];


    P(1)=30;
    P(2)=8/3;
    P(3)=10.0;

     DS(1).Val_param=P;

%  Integration data
     DS(1).time_start = 0.0;
     DS(1).time_end   = 1000.0;
     DS(1).max_step = 0.1;
     DS(1).abs_error = 0.000001;
     DS(1).rel_error = 0.00001;
     DS(1).method_int = 7;

%  DS data
     DS(1).name = 'lorenz';
     DS(1).vars = {'x' 'y' 'z'};
     DS(1).param ={'r' 'b' 'sigma'};
     DS(1).periodic={0 0 0};
     DS(1).periodic_value=[0 0 0];
     DS(1).equations = {'-sigma*(x-y)' ...
                   '-x*z+r*x-y' ...
                   'x*y-b*z' };


% Define current trajectory as initial point

     DS(1).currenttrajectory = 0;

% Define text output regime. 0 - no text output to main MATLAB window; 1 -
% trajectory points output to main MATLAB window.
% Always equilibria, cycles and other values print to main MATLAB window;
     DS(1).trj_text_out = 0;

% Regime of time output to main window
     DS(1).time_indication = 0;

% Define equation of poincare section {1} - lhs depending on variables {2}
% rhs const. In symbolic format.
     DS(1).poincare_map = [];
% Switch variable for poincare map calculation:   0 - no section; 1 - section on time; 
%                               2 - section by plane in both direction
%                               3 - section by plane in positive direction
%                               4 - section by plane in negative direction                          
     DS(1).poincare_do = 0;
% Define equation of poincare section for evaluation (in internal format)
     DS(1).poincare_eq = [];
% Current sign of section value
     DS(1).poincare_cur = 0;
     DS(1).poincare_nmbr = 0;
% Lyapunov exponents options
     DS(1).n_lyapunov = 0;
     DS(1).step_lyapunov = 0.5;
     DS(1).outstep_lyapunov = 10;

     neq=length(DS(1).vars);
     DS(1).Xinit=rand([1 neq]);


     for i=1:neq
       [errcd,sstrng]=expr_check(DS(1).equations{i},DS);
       DS(1).equations_w{i} = sstrng;
       DS(1).list_equation{i} = strcat(strcat(strcat(DS(1).vars{i},char(39)),'='),...
                                        DS(1).equations{i});
     end;


    [res,ss]=symbfind;
    if res==1
      for i=1:neq
       for j=1:neq
           DS(1).jacobian{i,j}=diff(sym(DS(1).equations{i}),DS(1).vars{j});
           [errcd,sstrng]=expr_check(DS(1).jacobian{i,j},DS);
           DS(1).jacobian_w{i,j} = [];
           DS(1).jacobian_w{i,j} = sstrng;
       end;
      end;
    else
      DS(1).jacobian = [];
    end;
    
% DS-files generations

     system_gen;

  end;



if nargin==0     % LAUNCH GUI

	fig = openfig(mfilename,'reuse');
        DS(1).windows(1) = fig;
        nbrwin = 0;

	% Generate a structure of handles to pass to callbacks, and store it. 
	handles = guihandles(fig);
	guidata(fig, handles);
        DS(1).mainwin = handles;


  Check_And_Load([matdspath.temp filesep 'temp']);  

        update_ds;


	if nargout > 0
		varargout{1} = fig;
	end

elseif ischar(varargin{1}) % INVOKE NAMED SUBFUNCTION OR CALLBACK

	try
		if (nargout)
			[varargout{1:nargout}] = feval(varargin{:}); % FEVAL switchyard
		else
			feval(varargin{:}); % FEVAL switchyard
		end
	catch
		disp(lasterr);
	end

end


%| ABOUT CALLBACKS:
%| GUIDE automatically appends subfunction prototypes to this file, and 
%| sets objects' callback properties to call them through the FEVAL 
%| switchyard above. This comment describes that mechanism.
%|
%| Each callback subfunction declaration has the following form:
%| <SUBFUNCTION_NAME>(H, EVENTDATA, HANDLES, VARARGIN)
%|
%| The subfunction name is composed using the object's Tag and the 
%| callback type separated by '_', e.g. 'slider2_Callback',
%| 'figure1_CloseRequestFcn', 'axis1_ButtondownFcn'.
%|
%| H is the callback object's handle (obtained using GCBO).
%|
%| EVENTDATA is empty, but reserved for future use.
%|
%| HANDLES is a structure containing handles of components in GUI using
%| tags as fieldnames, e.g. handles.figure1, handles.slider2. This
%| structure is created at GUI startup using GUIHANDLES and stored in
%| the figure's application data using GUIDATA. A copy of the structure
%| is passed to each callback.  You can store additional information in
%| this structure at GUI startup, and you can change the structure
%| during callbacks.  Call guidata(h, handles) after changing your
%| copy to replace the stored original so that subsequent callbacks see
%| the updates. Type "help guihandles" and "help guidata" for more
%| information.
%|
%| VARARGIN contains any extra arguments you have passed to the
%| callback. Specify the extra arguments by editing the callback
%| property in the inspector. By default, GUIDE sets the property to:
%| <MFILENAME>('<SUBFUNCTION_NAME>', gcbo, [], guidata(gcbo))
%| Add any extra arguments after the last argument, before the final
%| closing parenthesis.






% --------------------------------------------------------------------





% --------------------------------------------------------------------
function varargout = mCompute_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = mForward_Callback(h, eventdata, handles, varargin)
global calculation_progress first_call;
global DS;
global P;
global TRJ_bufer Time_bufer;
global bufer_i;
global driver_window;


nw = length(DS(1).windows);
if nw==1
   bb=errordlg('At least one output window must be open!','Calculation impossible!');
   return;
end;


   neq=size(DS.vars,2);


   set(DS(1).mainwin.mStatus_text,'String','busy...');
   set(DS(1).mainwin.mCompute,'Enable','off');
%   set(DS(1).mainwin.mWindow,'Enable','off');

if DS(1).time_start >= DS(1).time_end
   h=errordlg('Time start < time end. Correct it in integration data window.',...
              'Integration options error!');
   set(h,'WindowStyle','modal');

%  Correction of integration data

   itegrdata;
   return;      
end;

calc_driver;
calculation_progress = 1;
update_ds;

clear oderhs;
clear odeoutp;
clear ode_lin;
clear ode_jacob;

P=[];
P=DS(1).Val_param;
X=DS(1).Xinit;
% Period of variable calcullation
for i=1:neq
    if DS(1).periodic{i}~=0
       DS(1).periodic_value(i) = eval(DS(1).periodic{i});
    end;
end;

options = odeset('RelTol',DS(1).rel_error,'AbsTol',DS(1).abs_error,'MaxStep',DS(1).max_step,...
                 'OutputFcn',@odeoutp,'Refine',0,'InitialStep',0.001);
T_start = DS(1).time_start;

% Start 



first_call = 1;

if DS(1).n_lyapunov==0
   while calculation_progress == 1
      [T,Y] = integrator(DS(1).method_int,@oderhs,[T_start DS(1).time_end],X,options,P);
      first_call = 0;
      if calculation_progress==99, break; end;
      if ( T(size(T,1))<DS(1).time_end ) & (calculation_progress~=0)
         X = TRJ_bufer(bufer_i,:);
         T_start = Time_bufer(bufer_i);
         calculation_progress = 1;
      else
         calculation_progress = 0;
         if ~isempty(driver_window)
             if ishandle(driver_window)
                 delete(driver_window);
                 driver_window = [];
             end;         
         end;
      end;
   end;
else
    lyapunov(neq,T_start,DS(1).step_lyapunov,DS(1).time_end,X,round(DS(1).outstep_lyapunov / DS(1).step_lyapunov));
end;

calculation_progress=0;
update_ds;


% --------------------------------------------------------------------
function varargout = mResearch_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = mEquilibrium_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = mPeriodicSol_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = mInformation_Callback(h, eventdata, handles, varargin)



% --------------------------------------------------------------------
function varargout = mOut_text_Call(h, eventdata, handles, varargin)
global DS;

if strcmp(get(handles.mOut_text,'Checked'),'off') == 1
   set(handles.mOut_text,'Checked','on');   
   DS(1).trj_text_out = 1;
else
   set(handles.mOut_text,'Checked','off');
   DS(1).trj_text_out = 0;
end;   



