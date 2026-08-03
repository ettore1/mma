function varargout = itegrdata(varargin)
% ITEGRDATA Application M-file for itegrdata.fig
%    FIG = ITEGRDATA launch itegrdata GUI.
%    ITEGRDATA('callback_name', ...) invoke the named callback.

% Last Modified by GUIDE v2.0 30-Apr-2003 16:15:41

global DS;
global session_windows;


if nargin == 0  % LAUNCH GUI

	fig = openfig(mfilename,'reuse');

	% Use system color scheme for figure:
	set(fig,'Color',get(0,'defaultUicontrolBackgroundColor'));

        session_windows.intdata = fig;

	% Generate a structure of handles to pass to callbacks, and store it. 
	handles = guihandles(fig);
	guidata(fig, handles);

        set(handles.edit5,'String',num2str(DS(1).time_start) );
        set(handles.edit4,'String',num2str(DS(1).time_end) );
        set(handles.edit3,'String',num2str(DS(1).max_step) );
        set(handles.edit1,'String',num2str(DS(1).abs_error) );
        set(handles.edit2,'String',num2str(DS(1).rel_error) );
        set(handles.popupmenu1,'Value',DS(1).method_int);

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
function varargout = edit1_Callback(h, eventdata, handles, varargin)
set(h,'BackgroundColor',[0.83 0.83 0.83]);




% --------------------------------------------------------------------
function varargout = edit2_Callback(h, eventdata, handles, varargin)
set(h,'BackgroundColor',[0.83 0.83 0.83]);




% --------------------------------------------------------------------
function varargout = edit3_Callback(h, eventdata, handles, varargin)
set(h,'BackgroundColor',[0.83 0.83 0.83]);




% --------------------------------------------------------------------
function varargout = edit4_Callback(h, eventdata, handles, varargin)
set(h,'BackgroundColor',[0.83 0.83 0.83]);




% --------------------------------------------------------------------
function varargout = edit5_Callback(h, eventdata, handles, varargin)
set(h,'BackgroundColor',[0.83 0.83 0.83]);



% --------------------------------------------------------------------
function varargout = popupmenu1_Callback(h, eventdata, handles, varargin)
%global DS;
%DS.method_int = get(h,'Value')
set(h,'BackgroundColor',[0.83 0.83 0.83]);



% --------------------------------------------------------------------
function varargout = pushbutton1_Callback(h, eventdata, handles, varargin)
global DS;

neq = length(DS(1).vars);
npr = length(DS(1).param);
for i=1:neq
    X(i)=DS(1).Xinit(i);
end;
for i=1:npr
    P(i)=DS(1).Val_param(i);
end;


errcode = 0;


ed=findobj(gcf,'Tag','edit5');

    [errcd,sstrng]=expr_check(get(ed,'String'),DS);
     if errcd~=0 
        errcode = 1;
     else
        DS(1).time_start = eval(sstrng);
        set(ed,'String',num2str(DS(1).time_start));
        set(ed,'BackgroundColor',[1.0 1.0 1.0]);
     end;

     
ed=findobj(gcf,'Tag','edit4');

    [errcd,sstrng]=expr_check(get(ed,'String'),DS);
     if errcd~=0 
        errcode = 1;
     else
        DS(1).time_end = eval(sstrng);
        set(ed,'String',num2str(DS(1).time_end));
        set(ed,'BackgroundColor',[1.0 1.0 1.0]);
     end;


ed=findobj(gcf,'Tag','edit3');

    [errcd,sstrng]=expr_check(get(ed,'String'),DS);
     if errcd~=0 
        errcode = 1;
     else
        DS(1).max_step = eval(sstrng);
        set(ed,'String',num2str(DS(1).max_step));
        set(ed,'BackgroundColor',[1.0 1.0 1.0]);
     end;



ed=findobj(gcf,'Tag','edit1');

ss=get(ed,'String');

    [errcd,sstrng]=expr_check(ss,DS);
     if errcd~=0 
        errcode = 1;
     else
        DS(1).abs_error = eval(sstrng);
        set(ed,'String',num2str(DS(1).abs_error));
        set(ed,'BackgroundColor',[1.0 1.0 1.0]);
     end;
     
     
ed=findobj(gcf,'Tag','edit2');

[errcd,sstrng]=expr_check(get(ed,'String'),DS);
  
     if errcd~=0 
        errcode = 1;
     else
        DS(1).rel_error = eval(sstrng);
        set(ed,'String',num2str(DS(1).rel_error));
        set(ed,'BackgroundColor',[1.0 1.0 1.0]);
     end;

% Numerical method definition     
     
ed=findobj(gcf,'Tag','popupmenu1');
get(ed,'Value');

DS(1).method_int = get(ed,'Value');
set(ed,'BackgroundColor',[1.0 1.0 1.0]);


update_ds;

% --------------------------------------------------------------------
function varargout = pushbutton2_Callback(h, eventdata, handles, varargin)
global session_windows;

delete(gcf);
session_windows.intdata = [];
