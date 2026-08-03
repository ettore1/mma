function varargout = calc_driver(varargin)
% CALC_DRIVER Application M-file for calc_driver.fig
%    FIG = CALC_DRIVER launch calc_driver GUI.
%    CALC_DRIVER('callback_name', ...) invoke the named callback.

% Last Modified by GUIDE v2.0 30-Jan-2003 16:53:39

global driver_window;

if nargin == 0  % LAUNCH GUI

	fig = openfig(mfilename,'reuse');


        rr = get(fig,'Position');
        rr(1)=0; rr(2)=0;
        set(fig,'Position',rr);


	% Generate a structure of handles to pass to callbacks, and store it. 
	handles = guihandles(fig);

	guidata(fig, handles);

        driver_window = fig;

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
global driver_window;
global calculation_progress;
global DS;

% Continue calcullation

set(driver_window,'UserData',[0]);
calculation_progress = 1;

update_ds;


% --------------------------------------------------------------------
function varargout = pushbutton2_Callback(h, eventdata, handles, varargin)
global driver_window;
global calculation_progress;
global DS;


% pause of calcullation

set(driver_window,'UserData',[1]);
calculation_progress = 2;

update_ds;



% --------------------------------------------------------------------
function varargout = pushbutton3_Callback(h, eventdata, handles, varargin)
global driver_window;
global calculation_progress;
global DS;


calculation_progress = 99;

% output from calcullation
   set(driver_window,'UserData',[1]);

   delete(driver_window);

   update_ds;
  


% --------------------------------------------------------------------
function varargout = pushbutton4_Callback(h, eventdata, handles, varargin)

