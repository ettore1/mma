function varargout = param_set(varargin)
% PARAM_SET Application M-file for param_set.fig
%    FIG = PARAM_SET launch param_set GUI.
%    PARAM_SET('callback_name', ...) invoke the named callback.

% Last Modified by GUIDE v2.0 05-Feb-2003 17:18:09
global DS;
global session_windows;


if nargin == 0  % LAUNCH GUI


% Number of parameters checking 

npars = length(DS(1).param);
if npars == 0
    msgbox('Parameters not found in current system!','Sorry!');
    return;
end;

	fig = openfig(mfilename,'reuse');

	% Use system color scheme for figure:
	set(fig,'Color',get(0,'defaultUicontrolBackgroundColor'));

        session_windows.params = fig;

	% Generate a structure of handles to pass to callbacks, and store it. 
	handles = guihandles(fig);
	guidata(fig, handles);
    
if isempty(get(fig,'UserData'))==1
    u = findobj(fig,'Style','slider');
    set(u,'Value',[1.0]);
    Sl_Pos=get(u,'Position');
    Fig_Pos=get(fig,'Position');

    imore = 0;
    for i=1:npars
        ipos = Sl_Pos(2)+Sl_Pos(4)-2*i;
        if ipos<=Sl_Pos(2)
           imore = imore + 1;
        end;
    end;
    
    
    if imore == 0
      ipos = ipos-Sl_Pos(2);
      Sl_Pos(4) = Sl_Pos(4) - ipos;
      Fig_Pos = [Fig_Pos(1) Fig_Pos(2)+ipos Fig_Pos(3) Fig_Pos(4)-ipos];
      set(fig,'Position',Fig_Pos); 
     txt1=findobj(fig,'Tag','text1');
     rr=get(txt1,'Position');
     rr(2) = rr(2) - ipos;
     set(txt1,'Position',rr);
     txt1=findobj(fig,'Tag','text2');
     rr=get(txt1,'Position');
     rr(2) = rr(2) - ipos;
     set(txt1,'Position',rr);
    end;


    Fig_Pos=get(fig,'Position');
    imore = 0;
    UsrDat = [];
    UsrDat.strings = [];
    UsrDat.imore = [];
    UsrDat.old = 0;
    UsrDat.txt=[];
    UsrDat.edt=[];
    UsrDat.nbr=[];

    j=0;

    for i=1:npars
      UsrDat.strings{i} = num2str(DS(1).Val_param(i));
      ipos = Sl_Pos(2)+Sl_Pos(4)-2*i;
      if ipos>=Sl_Pos(2)
        j = j + 1;
        UsrDat.txt(i) = uicontrol(fig,'Style','Text','String',DS(1).param{i},'Units','characters',...
                  'Position',[2 ipos 10 1.5],'FontName','FixedWidth',...
                  'FontSize',12,...
                  'BackGroundColor',[1 1 1],'HorizontalAlignment','left');

        uicontrol(fig,'Style','Text','String','=','Units','characters',...
                  'Position',[12 ipos 1 1.5],'FontName','FixedWidth',...
                  'FontSize',12,...
                  'BackGroundColor',[1 1 1],'HorizontalAlignment','left');

        UsrDat.edt(i) = uicontrol(fig,'Style','Edit','String',UsrDat.strings{i},'Units','characters',...
                  'Position',[15 ipos 20 1.5],'FontName','FixedWidth',...
                  'FontSize',12,'ForegroundColor',[0 0 1],...
                  'BackGroundColor',[1 1 1],'HorizontalAlignment','left');
      else
       imore=imore+1;
      end;
    end;
    if imore==0 
      set(u,'Visible','off');
    else
      set(u,'Visible','on');
      set(u,'SliderStep',[1/imore 1/imore]);
    end;
    UsrDat.imore = imore;
    UsrDat.nbr = j;
    UsrDat.old = 0;
    set(gcf,'UserData',UsrDat);

end;
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
function varargout = slider1_Callback(h, eventdata, handles, varargin)
global DS;

npars=length(DS(1).vars);

% Scrolling control
UsrDat = get(gcf,'UserData');

for i=1:UsrDat.nbr
    UsrDat.strings{i+UsrDat.old} = get(UsrDat.edt(i),'String');
end;

rr=get(h,'Value');
step=get(h,'SliderStep');
izdvig = UsrDat.imore - round(rr/step(2));
for i=1:UsrDat.nbr
    set(UsrDat.txt(i),'String',DS(1).param{i+izdvig});         
    set(UsrDat.edt(i),'String',UsrDat.strings{i+izdvig});         
end;
UsrDat.old = izdvig;
set(gcf,'UserData',UsrDat);




% --------------------------------------------------------------------
function varargout = pushbutton1_Callback(h, eventdata, handles, varargin)
global DS;

UsrDat = get(gcf,'UserData');
npars = length(UsrDat.strings);
for i=1:UsrDat.nbr
    UsrDat.strings{i+UsrDat.old} = get(UsrDat.edt(i),'String');
end;

errcode = 0;
for i=1:npars
    [errcd,sstrng]=expr_check(UsrDat.strings{i},DS);
     if errcd~=0 
        errcode = 1;
     else
        calc_strings{i} = sstrng;
     end;
end;

if errcode == 0
   nvars = length(DS(1).vars);
   for i=1:nvars
     X(i) = DS(1).Xinit(i); 
   end;
   for i=1:npars
     P(i) = DS(1).Val_param(i);
   end;
   for i=1:npars
      ss=eval(calc_strings{i});
      DS(1).Val_param(i) = ss;
   end;

   for i=1:npars
       UsrDat.strings{i} = num2str(DS(1).Val_param(i));
   end;
   for i=1:UsrDat.nbr
       set(UsrDat.edt(i),'String',UsrDat.strings{i+UsrDat.old});
   end;

else
   errordlg('Error in values of variables found! Check, please!','Error!','reuse'); 
end;

   set(gcf,'WindowStyle','normal');




% --------------------------------------------------------------------
function varargout = pushbutton2_Callback(h, eventdata, handles, varargin)
global P;

UsrDat = get(gcf,'UserData');
npars = length(UsrDat.strings);
for i=1:npars
    UsrDat.strings{i} = num2str(P(i));
end;
for i=1:UsrDat.nbr
    set(UsrDat.edt(i),'String',UsrDat.strings{i+UsrDat.old});
end;




% --------------------------------------------------------------------
function varargout = pushbutton3_Callback(h, eventdata, handles, varargin)
global session_windows;

delete(session_windows.params);
session_windows.params = [];

