function varargout = var_set2D(varargin)
% VAR_SET2D Application M-file for var_set2D.fig
%    FIG = VAR_SET2D launch var_set2D GUI.
%    VAR_SET2D('callback_name', ...) invoke the named callback.

% Last Modified by GUIDE v2.0 07-Feb-2003 02:18:49

if nargin == 0  % LAUNCH GUI

        parent_fig = gcf;

        ff=get(parent_fig,'UserData');
        sedit1 = ff.Xexpression;
        sedit2 = ff.Yexpression;

	fig = openfig(mfilename,'reuse');

	% Use system color scheme for figure:
	set(fig,'Color',get(0,'defaultUicontrolBackgroundColor'),'UserData',parent_fig);

	% Generate a structure of handles to pass to callbacks, and store it. 
	handles = guihandles(fig);
	guidata(fig, handles);

        set(fig,'WindowStyle','modal');


        ed1=findobj(gcf,'Tag','edit1');
        set(ed1,'String',sedit1);
        ed1=findobj(gcf,'Tag','edit2');
        set(ed1,'String',sedit2);

        ed1=findobj(gcf,'Tag','checkbox1');
        set(ed1,'Value',ff.Xscaling);
        ed1=findobj(gcf,'Tag','checkbox2');
        set(ed1,'Value',ff.Yscaling);


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
function varargout = pushbutton1_Callback(h, eventdata, handles, varargin)
global DS;

    parent_fig = get(gcf,'UserData');

    ff = get(parent_fig,'UserData');

errcode = 0;

ed1=findobj(gcf,'Tag','edit1');

    [errcd,sstrng]=expr_check(lower(get(ed1,'String')),DS);
     if errcd~=0 
        errcode = 1;
     else
        ff.Xvalue = sstrng;
        ff.Xexpression = get(ed1,'String');
     end;

ed1=findobj(gcf,'Tag','edit2');

    [errcd,sstrng]=expr_check(lower(get(ed1,'String')),DS);
     if errcd~=0 
        errcode = 1;
     else
        ff.Yvalue = sstrng;
        ff.Yexpression = get(ed1,'String');
     end;

    if errcode==0   
     ed1=findobj(gcf,'Tag','checkbox1');
        ff.Xscaling = get(ed1,'Value');
     ed1=findobj(gcf,'Tag','checkbox2');
        ff.Yscaling = get(ed1,'Value');
    
     set(parent_fig,'UserData',ff);
     delete(gcf);


     axx=findobj(parent_fig,'type','axes');
     deflt=get(axx,'Units');
     set(axx,'Units','Characters');
     Pos_ax=get(axx,'Position');
     set(axx,'Units',deflt);

      xlabel(ff.Xexpression,'Units','Characters','Position',[Pos_ax(3)/2 -1.2],...
             'FontSize',10.0,'HorizontalAlignment','center');
      ylabel(ff.Yexpression,'Units','Characters','Position',[-5 Pos_ax(4)/2],...
             'FontSize',10.0,'HorizontalAlignment','center','Rotation',90);

    end;

% --------------------------------------------------------------------
function varargout = pushbutton2_Callback(h, eventdata, handles, varargin)
delete(gcf);



% --------------------------------------------------------------------
function varargout = edit1_Callback(h, eventdata, handles, varargin)
set(h,'BackgroundColor',[0.83 0.83 0.83]);



% --------------------------------------------------------------------
function varargout = edit2_Callback(h, eventdata, handles, varargin)
set(h,'BackgroundColor',[0.83 0.83 0.83]);



% --------------------------------------------------------------------
function varargout = checkbox1_Callback(h, eventdata, handles, varargin)



% --------------------------------------------------------------------
function varargout = checkbox2_Callback(h, eventdata, handles, varargin)

