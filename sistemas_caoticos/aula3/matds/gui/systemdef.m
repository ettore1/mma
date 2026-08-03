function varargout = systemdef(varargin)
global DS;
global session_windows;
global DSa;

% SYSTEMDEF Application M-file for systemdef.fig
%    FIG = SYSTEMDEF launch systemdef GUI.
%    SYSTEMDEF('callback_name', ...) invoke the named callback.

% Last Modified by GUIDE v2.0 18-Jan-2003 02:15:52

if nargin == 0  % LAUNCH GUI

  if length(session_windows.vars)~=0
     delete(session_windows.vars);
     session_windows.vars = [];
  end;

  if length(session_windows.params)~=0
     delete(session_windows.params);
     session_windows.params = [];
  end;

   button = questdlg('Do you want to save current MATDS session?',...
                     'The current session will delete!','Yes','No','Yes');
   if strcmp(button,'Yes')
      Save_As;
   end;

   DSa(1).name = DS(1).name;
   DSa(1).vars = DS(1).vars;
   DSa(1).param = DS(1).param;
   DSa(1).Val_param = DS(1).Val_param;
   DSa(1).equations = DS(1).equations;
   DSa(1).periodic = DS(1).periodic;
   DSa(1).currenttrajectory = 0;
   DSa(1).method_int = DS(1).method_int;

	fig = openfig(mfilename,'reuse');

	% Use system color scheme for figure:
	set(fig,'Color',get(0,'defaultUicontrolBackgroundColor'));

	% Generate a structure of handles to pass to callbacks, and store it. 
	handles = guihandles(fig);


	guidata(fig, handles);
        session_windows.sysdef = handles;

% 
%       Get information from DS-structure
%
        rr = size(DS(1).vars);
        nds = rr(2);
        rr = DS(1).vars(1);
        for i=2:nds
            rr=strcat(rr,',');
            rr=strcat(rr,DS(1).vars(i));
        end;
        set(handles.edit2,'String',rr);

        rr = size(DS(1).param);
        nprm = rr(2);
        if nprm==0
           rr = {'param'};
           DS(1).param{1}='param';
           DS(1).Val_param(1)=0;
        else
           rr = DS(1).param(1);
        end;
        for i=2:nprm
            rr=strcat(rr,',');
            rr=strcat(rr,DS(1).param(i));
        end;
        set(handles.edit3,'String',rr);

        set(handles.edit1,'String',DS(1).name);

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
function varargout = radiobutton1_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = radiobutton2_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = pushbutton1_Callback(h, eventdata, handles, varargin)
global DSa;

errcode = 0;

% Name control
ss = get(handles.edit1,'String');
if ~isempty(ss)
   DSa(1).name = ss;
   sk = size(ss);
   sk = sk(2);
   if checksymb(ss(1))<2
       errordlg('Bad first symbol in the system name','DS-error!');
       errcode = 1;
   else
   for i=2:sk
       if checksymb(ss(i))==0
          errordlg(strcat(strcat('Bad symbol number ',int2str(i)),' in the system name'),'DS-error!','on');
          errcode = 1;
      end;
   end;
end;
else
   errordlg('Name of system is empty!','DS-error!','on');
   errcode = 1;
end;
if (errcode == 0) 
    DSa(1).name = ss;
end;


% Coordinates control

ss = lower(get(handles.edit2,'String'));
if ~isempty(ss)
   ss = ss{1};
   sk = size(ss);
   sk = sk(2)+1;
   s1 = strfind(ss,',');
   s2 = strfind(ss,' ');
   sn = sort([0 s1 s2 sk]);
   sk = size(sn);
   sk = sk(2);
   kn = 0;
   for i=1:(sk-1)
       sk = '';
       for j=(sn(i)+1):(sn(i+1)-1)
           if ( j==(sn(i)+1) )
               if checksymb(ss(j))<2
                  errordlg('Bad first symbol in variable name','DS-error!','on');
                  errcode = 1;
              end;    
           else
               if checksymb(ss(j))==0
                  errordlg('Bad symbol in variables names','DS-error!','on');
                  errcode = 1;
      end;
           end;
           sk = strcat(sk,ss(j));
       end;
       if ~isempty(sk)
           kn = kn + 1;
           tmp{kn} = sk;
       end;
   end;
   DSa(1).vars = tmp;
   rr = size(DSa(1).vars);
   nds = rr(2);
   rr = DSa(1).vars(1);
   for i=2:nds
       rr=strcat(rr,',');
       rr=strcat(rr,DSa(1).vars(i));
   end;
   set(handles.edit2,'String',rr);
else
   errordlg('Coordinates not found !!!','DS-error!','on');
   errcode = 1;
end;


% Parameters control
DSa(1).param = [];
DSa(1).Val_param = [];
tmp1 = [];

ss = lower(get(handles.edit3,'String'));
if ~isempty(ss)
    sk = size(ss{1});
    sk = sk(2);
    s1 = strfind(ss{1},' ');
    s2 = strfind(ss{1},',');
    sn = sort([s1 s2]);
    sn = size(sn);
    sn = sn(2);
    if sk == sn
       ss{1}=[];
       set(handles.edit3,'String',ss);
    end;    
end;

ss = lower(get(handles.edit3,'String'));
if (~isempty(ss)) & ( ~isempty(ss{1}) )
   ss = ss{1};
   sk = size(ss);
   sk = sk(2)+1;
   s1 = strfind(ss,',');
   s2 = strfind(ss,' ');
   sn = sort([0 s1 s2 sk]);
   sk = size(sn);
   sk = sk(2);
   kn = 0;
   for i=1:(sk-1)
       sk = '';
       for j=(sn(i)+1):(sn(i+1)-1)
           if ( j==(sn(i)+1) )
               if checksymb(ss(j))<2
                  errordlg('Bad first symbol in parameter name','DS-error!','on');
                  errcode = 1;
              end;    
           else
               if checksymb(ss(j))==0
                  errordlg('Bad symbol in parameters names','DS-error!','on');
                  errcode = 1;
      end;
           end;
           sk = strcat(sk,ss(j));
       end;
       if ~isempty(sk)
           kn = kn + 1;
           tmp1{kn} = sk;
       end;
   end;
   
   DSa(1).param = tmp1;
   rr = size(DSa(1).param);
   nds = rr(2);

   rr = DSa(1).param(1);
   for i=2:nds
       rr=strcat(rr,',');
       rr=strcat(rr,DSa(1).param(i));
   end;
   set(handles.edit3,'String',rr);
end;

   kn  = size(tmp);
   if (kn(1)>0)
       kn = kn(2);
   else 
       kn = 0;
   end;

   kn1 = size(tmp1);
   if (kn1(1)>0)
       kn1 = kn1(2);
   else 
       kn1 = 0;
   end;

   for i=1:kn
     if isequal('t',tmp{i})==1
        errordlg('t - is a name of independent variable','Error name!','on');
        errcode = 1;
     end; 
     for j=(i+1):kn
         if (isequal(tmp{i},tmp{j})==1)
             errordlg('Double names of variable!!!','Error names!','on');
             errcode = 1;
          end;
     end;
   end;

   for i=1:kn1
     if isequal('t',tmp1{i})==1
        errordlg('t - is a name of independent variable','Error name!','on');
        errcode = 1;
     end; 
     for j=(i+1):kn1
         if (isequal(tmp1{i},tmp1{j})==1)
             errordlg('Double names of parameters!!!','Error names!','on');
             errcode = 1;
          end;
     end;
   end;

   for i=1:kn
     for j=1:kn1
         if (isequal(tmp{i},tmp1{j})==1)
             errordlg('The variables and parameters names are same!!!','Error names!','on');
             errcode = 1;
          end;
     end;
   end;


   rr = size(DSa(1).vars);
   nds = rr(2);
   tempeq = DSa(1).equations;
   tempper = DSa(1).periodic;

   rr = size(tempeq);
   neq = rr(2);

   DSa(1).equations = [];
   DSa(1).list_equation = [];
   DSa(1).periodic = [];
   for i=1:nds
       if i<=neq
          DSa(1).equations{i} = tempeq{i};
          DSa(1).periodic{i} = tempper{i};          
       else
          DSa(1).equations{i} = '< not defined >';
          DSa(1).periodic{i} = 0;
       end;
       DSa(1).list_equation{i} = strcat(strcat(strcat(DSa(1).vars{i},char(39)),'='),...
                                        DSa(1).equations{i});
   end;


if errcode == 0
    ff = systemedit;
end;

% --------------------------------------------------------------------
% --------------------------------------------------------------------
function varargout = closeproc(h, eventdata, handles, varargin)
errordlg('This window will be close after second step of system definition!!!','Error action!','on');


% --------------------------------------------------------------------
function varargout = edit3_Callback(h, eventdata, handles, varargin)

