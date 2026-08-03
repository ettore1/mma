function varargout = poincare_set(varargin)
% POINCARE_SET M-file for poincare_set.fig
%      POINCARE_SET, by itself, creates a new POINCARE_SET or raises the existing
%      singleton*.
%
%      H = POINCARE_SET returns the handle to a new POINCARE_SET or the handle to
%      the existing singleton*.
%
%      POINCARE_SET('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in POINCARE_SET.M with the given input arguments.
%
%      POINCARE_SET('Property','Value',...) creates a new POINCARE_SET or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before poincare_set_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to poincare_set_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help poincare_set

% Last Modified by GUIDE v2.5 12-Nov-2003 12:19:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @poincare_set_OpeningFcn, ...
                   'gui_OutputFcn',  @poincare_set_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before poincare_set is made visible.
function poincare_set_OpeningFcn(hObject, eventdata, handles, varargin)
global DS;
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to poincare_set (see VARARGIN)

% Choose default command line output for poincare_set
set(gcf,'WindowStyle','modal');
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes poincare_set wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% Initial input values
set(handles.edit2,'String',DS(1).vars{1});
set(handles.edit1,'String','0');
set(handles.edit3,'String','3.141592653589793');
if ~isempty(DS(1).poincare_map)
    if DS(1).poincare_do>1
        set(handles.edit2,'String',DS(1).poincare_map{1});
        set(handles.edit1,'String',DS(1).poincare_map{2});
    else
        set(handles.edit3,'String',DS(1).poincare_map{2});
    end
end
set(handles.pushbutton1,'Enable','off');

% --- Outputs from this function are returned to the command line.
function varargout = poincare_set_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2
set(handles.pushbutton1,'Enable','on');
if get(handles.checkbox2,'Value')==0
   set(handles.checkbox3,'Value',1);
   set(handles.edit1,'Visible','on');
   set(handles.edit2,'Visible','on');
   set(handles.text2,'Visible','on');
   set(handles.text3,'Visible','on');
   set(handles.text4,'Visible','on');
   set(handles.text5,'Visible','on');
   set(handles.popupmenu1,'Visible','on');
   set(handles.text6,'Visible','off');
   set(handles.edit3,'Visible','off');
else 
   set(handles.checkbox3,'Value',0);
   set(handles.edit1,'Visible','off');
   set(handles.edit2,'Visible','off');
   set(handles.text2,'Visible','off');
   set(handles.text3,'Visible','off');
   set(handles.text4,'Visible','off');
   set(handles.text5,'Visible','off');
   set(handles.popupmenu1,'Visible','off');
   set(handles.text6,'Visible','on');
   set(handles.edit3,'Visible','on');
end;

% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3
set(handles.pushbutton1,'Enable','on');

if get(handles.checkbox3,'Value')==0
   set(handles.checkbox2,'Value',1);
   set(handles.edit1,'Visible','off');
   set(handles.edit2,'Visible','off');
   set(handles.text2,'Visible','off');
   set(handles.text3,'Visible','off');
   set(handles.text4,'Visible','off');
   set(handles.text5,'Visible','off');
   set(handles.popupmenu1,'Visible','off');
   set(handles.text6,'Visible','on');
   set(handles.edit3,'Visible','on');
else 
   set(handles.checkbox2,'Value',0);
   set(handles.edit1,'Visible','on');
   set(handles.edit2,'Visible','on');
   set(handles.text2,'Visible','on');
   set(handles.text3,'Visible','on');
   set(handles.text4,'Visible','on');
   set(handles.text5,'Visible','on');
   set(handles.popupmenu1,'Visible','on');
   set(handles.text6,'Visible','off');
   set(handles.edit3,'Visible','off');
end;


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
global DS;
global TRJ_bufer Time_bufer bufer_i;

% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
errorcode = 0;
if get(handles.checkbox3,'Value')==1
    strng = get(handles.edit2,'String');
    [errcd,sstrng]=expr_check(strng,DS);
    if errcd~=0
        errordlg('Error in LHS of section equation!!!');
        errorcode = 1;
    else 
        DS(1).poincare_map{1}=strng;
        strng = get(handles.edit1,'String');
        [errcd,sstrng1]=expr_check(strng,DS);
        if errcd~=0
            errordlg('Error in RHS of section equation!!!');
            errorcode = 1;
        else 
    % All is OK         
            DS(1).poincare_map{2}=strng;
            DS(1).poincare_eq = [sstrng '-' sstrng1];
            DS(1).poincare_do = get(handles.popupmenu1,'Value')+1;
            X = DS(1).Xinit;
            DS(1).poincare_cur = eval(DS(1).poincare_eq);
            DS(1).poincare_nmbr = 0;
        end 
    end
else
    strng = get(handles.edit3,'String');
    [errcd,sstrng]=expr_check(strng,DS);
    if errcd~=0
        errordlg('Error in expression for time step!!!');
        errorcode = 1;
    else 
        DS(1).poincare_map{1}='t';
        DS(1).poincare_map{2}=strng;
        DS(1).poincare_eq = sstrng;
        DS(1).poincare_do = 1;
        DS(1).poincare_cur = DS(1).time_start;       
        DS(1).poincare_nmbr = 0;
    end
end

if errorcode == 0
    update_ds; delete(gcf);
        nwind = size(DS.windows);
        nwind = nwind(2)-1;
         for i=1:nwind
             ff = get(DS(1).windows(i+1),'UserData');
             figure(DS(1).windows(i+1)); 
             X = TRJ_bufer(bufer_i,:);
             t = Time_bufer(bufer_i);
             if ff.type == 1
                 gg=findobj(DS(1).windows(i+1),'Tag','mPoincarePlot2D');
                 set(gg,'Enable','on');
                 Xp = eval(ff.Xvalue);
                 Yp = eval(ff.Yvalue);
                 ff.poinc_trj=line(Xp,Yp,'Marker','.','EraseMode','none','LineStyle','none','MarkerSize',1);
             else
                 gg=findobj(DS(1).windows(i+1),'Tag','mPoincarePlot3D');
                 set(gg,'Enable','on');                 
                 Xp = eval(ff.Xvalue);
                 Yp = eval(ff.Yvalue);
                 Zp = eval(ff.Zvalue);
                 ff.poinc_trj=line(Xp,Yp,Zp,'Marker','.','EraseMode','none','LineStyle','none','MarkerSize',1);
             end 
             set(ff.poinc_trj,'Color',[0 0 0]);
             uisetcolor(ff.poinc_trj,['Points color' ' in ' get(gcf,'Name')]);
             set(DS(1).windows(i+1),'UserData',ff);
         end
end

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
global DS
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%  Poincare map is empty!!! 
%  Equations of poincare section
      DS(1).poincare_do = 0;
      DS(1).poincare_eq = [];
      DS(1).poincare_cur = 0;
      DS(1).poincare_map = [];
      DS(1).poincare_nmbr = 0;
        nwind = size(DS.windows);
        nwind = nwind(2)-1;
       for i=1:nwind
             ff = get(DS(1).windows(i+1),'UserData');
             if ff.type == 1
                 gg=findobj(DS(1).windows(i+1),'Tag','mPoincarePlot2D');
                 set(gg,'Enable','off'); 
             else
                 gg=findobj(DS(1).windows(i+1),'Tag','mPoincarePlot3D');
                 set(gg,'Enable','off');                 
             end
       end

      update_ds;
      delete(gcf);


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


