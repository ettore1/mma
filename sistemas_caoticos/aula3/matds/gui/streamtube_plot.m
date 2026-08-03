function varargout = streamtube_plot(varargin)
% STREAMTUBE_PLOT Application M-file for streamtube_plot.fig
%    FIG = STREAMTUBE_PLOT launch streamtube_plot GUI.
%    STREAMTUBE_PLOT('callback_name', ...) invoke the named callback.

% Last Modified by GUIDE v2.0 11-Jun-2003 18:14:42

if nargin == 0  % LAUNCH GUI

	fig = openfig(mfilename,'reuse');

	% Use system color scheme for figure:
	set(fig,'Color',get(0,'defaultUicontrolBackgroundColor'));

	% Generate a structure of handles to pass to callbacks, and store it. 
	handles = guihandles(fig);
	guidata(fig, handles);
        set(fig,'WindowStyle','modal');

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



% --------------------------------------------------------------------
function varargout = edit2_Callback(h, eventdata, handles, varargin)



% --------------------------------------------------------------------
function varargout = pushbutton1_Callback(h, eventdata, handles, varargin)
global win_to_draw;
global DS;
global vfield;
global P;

figure(win_to_draw);
set(win_to_draw,'WindowStyle','modal');
fig_axes = findobj(win_to_draw,'type','axes');

% Axes size
xsize = get(fig_axes,'Xlim');
ysize = get(fig_axes,'Ylim');
zsize = get(fig_axes,'Zlim');
% Grid parameters
nx = str2num(get(handles.edit1,'String'));
ny = str2num(get(handles.edit2,'String'));
nz = str2num(get(handles.edit3,'String'));

scaletube = str2num(get(handles.edit4,'String'));


if ( ~isempty(nx) ) & ( ~isempty(ny) ) & ( ~isempty(nz) ) & (~isempty(scaletube))
% Check variables
   ss = get(win_to_draw,'UserData');

   nbrvar = [0 0 0];
   neq=length(DS(1).vars);
   for i=1:neq
       if strcmp(ss.Xexpression,DS(1).vars{i})==1
          nbrvar(1) = i;
       end;
       if strcmp(ss.Yexpression,DS(1).vars{i})==1
          nbrvar(2) = i;
       end;
       if strcmp(ss.Zexpression,DS(1).vars{i})==1
          nbrvar(3) = i;
       end;
   end;


% Define grid
    hx =( xsize(2) - xsize(1) ) / (nx-1);
    hy =( ysize(2) - ysize(1) ) / (ny-1);
    hz =( zsize(2) - zsize(1) ) / (nz-1);
   [Xgrd,Ygrd,Zgrd] = meshgrid(xsize(1):hx:xsize(2),ysize(1):hy:ysize(2),zsize(1):hz:zsize(2));
   DX=Xgrd; DY=Ygrd; DZ=Zgrd;
   ns = size(DX);
%   meswin=msgbox('Please wait...');
% RHS calcullation
   X=DS(1).Xinit;
   t=DS(1).time_start;
   for i=1:ns(1)
   for j=1:ns(2)
   for k=1:ns(3)
       X(nbrvar(1)) = Xgrd(i,j,k);
       X(nbrvar(2)) = Ygrd(i,j,k);
       X(nbrvar(3)) = Zgrd(i,j,k);
       Y=oderhs(t,X,P);
       DX(i,j,k) = Y(nbrvar(1));
       DY(i,j,k) = Y(nbrvar(2));     
       DZ(i,j,k) = Y(nbrvar(3));     
   end;
   end;
   end;
   X=DS(1).Xinit;
   [startx,starty,startz] = meshgrid( X(nbrvar(1)) ,X(nbrvar(2)), X(nbrvar(3)) );

% Stream tube
   vfield=streamtube(Xgrd,Ygrd,Zgrd,DX,DY,DZ,startx,starty,startz,[scaletube 25]);
   shading interp;
   camlight; lighting gouraud
%   delete(meswin);
else
   errordlg('Check input parameters, please!','Error values!');
end;

set(win_to_draw,'WindowStyle','modal');
set(win_to_draw,'WindowStyle','normal');


% --------------------------------------------------------------------
function varargout = pushbutton3_Callback(h, eventdata, handles, varargin)
% Close field windows
global win_to_draw;


delete(gcf);
figure(win_to_draw);




% --------------------------------------------------------------------
function varargout = edit3_Callback(h, eventdata, handles, varargin)

% --------------------------------------------------------------------
function varargout = edit4_Callback(h, eventdata, handles, varargin)

