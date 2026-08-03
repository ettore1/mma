function varargout = systemedit(varargin)

% SYSTEMEDIT Application M-file for systemedit.fig
%    FIG = SYSTEMEDIT launch systemedit GUI.
%    SYSTEMEDIT('callback_name', ...) invoke the named callback.

% Last Modified by GUIDE v2.0 20-Jan-2003 00:41:51

global DSa DS;
global session_windows;

if nargin == 0  % LAUNCH GUI

        if isempty(session_windows.sysdef)
           DSa(1).name = DS(1).name;
           DSa(1).vars = DS(1).vars;
           DSa(1).param = DS(1).param;
           DSa(1).equations = DS(1).equations;
           DSa(1).equations_w = DS(1).equations_w;
           DSa(1).jacobian = DS(1).jacobian;
           DSa(1).jacobian_w = DS(1).jacobian_w;
           DSa(1).periodic = DS(1).periodic;
           DSa(1).list_equation = DS(1).list_equation;
           DSa(1).Val_param = DS(1).Val_param;
           DSa(1).currenttrajectory = 0;
           1
           DSa(1).method_int = DS(1).method_int;
        end;
	fig = openfig(mfilename,'reuse');

	% Use system color scheme for figure:
	set(fig,'Color',get(0,'defaultUicontrolBackgroundColor'));

	% Generate a structure of handles to pass to callbacks, and store it. 
	handles = guihandles(fig);

        session_windows.editsys = handles;

	guidata(fig, handles);
   
    
%  Equations list out

    set(handles.listbox1,'String',DSa(1).list_equation,'Value',[1]);
		varargout{1} = handles;

%  Name of DS out
    set(handles.text1,'String',strcat('Name: ',DSa(1).name));

%  Title for edit equation out
    set(handles.text5,'String',strcat('Equation for variable ',...
                               [' ' DSa(1).vars{1}]));

%  Small title for edit equation out
    tmp=strcat(strcat(DSa(1).vars{1},char(39)),'=');
    set(handles.text9,'String',tmp);
    
%  Equation for edit out
    set(handles.edit1,'String',DSa(1).equations{1});

%  Periodicity for variable checking
    if DSa(1).periodic{1}==0
       set(handles.checkbox1,'Value',[0]);
       set(handles.edit2,'String','6.283185308');
    else
       set(handles.checkbox1,'Value',[1]);
       set(handles.edit2,'String',DSa(1).periodic{1});
    end;

    if get(handles.checkbox1,'Value')==0
       set(handles.text7,'Visible','off');
       set(handles.edit2,'Visible','off');
    else
       set(handles.text7,'Visible','on');
       set(handles.edit2,'Visible','on');
    end;
    
%	if nargout > 0
%		varargout{1} = fig;
%	end

%    pause

    
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
function varargout = closeproc(h, eventdata, handles, varargin)
global DSa;
global session_windows;

if ~isempty(session_windows.sysdef)
   delete(session_windows.sysdef.figure1);
end;

delete(session_windows.editsys.figure_edit);

clear global DSa;
session_windows.sysdef=[];
session_windows.editsys=[];

% --------------------------------------------------------------------
function varargout = listbox1_Callback(h, eventdata, handles, varargin)
global DSa;

   set(handles.listbox1,'String',DSa(1).list_equation);  
   k = get(handles.listbox1,'Value');


%  Title for edit equation out
    set(handles.text5,'String',strcat('Equation for variable ',...
                               [' ' DSa(1).vars{k}]));

%  Small title for edit equation out
    tmp=strcat(strcat(DSa(1).vars{k},char(39)),'=');
    set(handles.text9,'String',tmp);
    
%  Equation for edit out
    set(handles.edit1,'String',DSa(1).equations{k});

%  Periodicity for variable checking
    if DSa(1).periodic{k}==0
        set(handles.checkbox1,'Value',[0]);
        set(handles.edit2,'String','6.283185308');
    else
        set(handles.checkbox1,'Value',[1]);
        if DSa(1).periodic{k}~=0
           set(handles.edit2,'String',DSa(1).periodic{k});
        end;
    end;    

    if get(handles.checkbox1,'Value')==0
       set(handles.text7,'Visible','off');
       set(handles.edit2,'Visible','off');
    else
       set(handles.text7,'Visible','on');
       set(handles.edit2,'Visible','on');
    end;




% --------------------------------------------------------------------
function varargout = edit1_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = pushbutton1_Callback(h, eventdata, handles, varargin)
global DSa;
% edit equation checking
number_eq = get(handles.listbox1,'Value'); 
[errcode,sstrng]=expr_check(get(handles.edit1,'String'),DSa);
if errcode==0
   DSa.equations{number_eq} = get(handles.edit1,'String');
   ss = get(handles.listbox1,'String');
   sstmp = strcat(strcat(strcat(DSa(1).vars{number_eq},char(39)),'='),...
           DSa(1).equations{number_eq});
   DSa(1).list_equation{number_eq} = sstmp;   
   ss{number_eq} = sstmp;
   set(handles.listbox1,'String',ss);
end;


if get(handles.checkbox1,'Value')==1
   [errcode1,sstrng1]=expr_check(get(handles.edit2,'String'),DSa);
   if errcode1==0
      DSa(1).periodic{number_eq}=sstrng1;
   end;
end;
number_eq = get(handles.listbox1,'Value'); 



% --------------------------------------------------------------------
function varargout = pushbutton2_Callback(h, eventdata, handles, varargin)
global DS;
global DSa;
global WasChanged;
global nbrwin;


n_eq = size(DSa(1).vars);
n_eq = n_eq(2);
errcode = 0;
strmsgeq = 'Error equations N';
strmsgpr = 'Error period vor values N';
DSa.equations_w = [];
for i=1:n_eq
    [errcd,sstrng]=expr_check(DSa.equations{i},DSa);
    if errcd~=0
       errcode = errcode + 1;
       strmsgeq = [strmsgeq ' ' int2str(i) ','];       
    else
       DSa.equations_w{i} = sstrng;
    end;
    if DSa(1).periodic{i} ~= 0
       [errcd,sstrng]=expr_check(DSa.periodic{i},DSa);
       if errcd~=0
          errcode = errcode + 1;
          strmsgpr = [strmsgpr ' ' int2str(i) ','];       
       end;
    end;
end;

DSa(1).jacobian_w = [];
if errcode == 0
   [res,ss]=symbfind;
   if res==1
      for i=1:n_eq
         for j=1:n_eq
           DSa(1).jacobian{i,j} = [];
           DSa(1).jacobian{i,j}=diff(sym(DSa(1).equations{i}),DSa(1).vars{j});
           [errcd,sstrng]=expr_check(DSa.jacobian{i,j},DSa);
           DSa(1).jacobian_w{i,j} = [];
           DSa(1).jacobian_w{i,j} = sstrng;
         end;
      end;
      ss = [ss '. Jacobian was calculated symbolically!'];
   else
      DSa(1).jacobian = [];
      ss = [ss '. Jacobian will calculate numerically!'];
   end;

%  Update system  
   DS(1).time_start = 0.0;
   DS(1).time_end   = 100.0;
   DS(1).max_step = 0.1;
   DS(1).abs_error = 0.000001;
   DS(1).rel_error = 0.00001;
   DS(1).method_int = 7;

   DS(1).name = DSa(1).name;
   DS(1).vars = DSa(1).vars;
   DS(1).param = DSa(1).param;
   DS(1).equations = DSa(1).equations;
   DS(1).equations_w = DSa(1).equations_w;
   DS(1).jacobian = DSa(1).jacobian;
   DS(1).jacobian_w = DSa(1).jacobian_w;
   DS(1).periodic = DSa(1).periodic;
   DS(1).list_equation = DSa(1).list_equation;
   DS(1).method_int = DSa(1).method_int;


   neq_old = length(DS(1).Xinit);
   Xold = DS(1).Xinit;
   DS(1).Xinit=[];  
   neq=length(DS(1).vars);
   for i=1:neq
       if i<=neq_old
          DS(1).Xinit(i)=Xold(i);
       else
          DS(1).Xinit(i)=rand;
       end;
   end;

   npar_old = length(DS(1).Val_param);
   Pold = DS(1).Val_param;
   DS(1).Val_param=[];  
   npar=length(DS(1).param);
   for i=1:npar
       if i<=npar_old
          DS(1).Val_param(i)=Pold(i);
       else
          DS(1).Val_param(i)=rand;
       end;
   end;

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
% Lyapunov value set
     DS(1).n_lyapunov = 0;

   closeproc(h, eventdata, handles, varargin);


%  Generation DS-file
   system_gen;

%  Menu update
   update_ds;

% Delete all plot windows
   close_win;
   nbrwin = 0;

% Parameters setting
   param_set;

% Vars setting
   vars_set;


   u=msgbox(ss,'Dynamical system was update successfully!!!');
   set(u,'WindowStyle','modal');


else
  buttom = questdlg(['Found ' int2str(errcode) ' errors: ' strmsgeq strmsgpr],...
                    'Error DS','Continue editing','Abort DS','Continue editing');
  if strcmp(buttom,'Abort DS')
   closeproc(h, eventdata, handles, varargin);
  end;
end;


% --------------------------------------------------------------------
function varargout = checkbox1_Callback(h, eventdata, handles, varargin)
global DSa;
    k = get(handles.listbox1,'Value');
    if get(handles.checkbox1,'Value')==0
       set(handles.text7,'Visible','off');
       set(handles.edit2,'Visible','off');
       DSa(1).periodic{k}=0;       
    else
       set(handles.text7,'Visible','on');
       set(handles.edit2,'Visible','on');
       if DSa(1).periodic{k}~=0
          set(handles.edit2,'String',DSa(1).periodic{k});
       end;
    end;




% --------------------------------------------------------------------
function varargout = edit2_Callback(h, eventdata, handles, varargin)

