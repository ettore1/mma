function varargout = lyapunov_set(varargin)
% LYAPUNOV_SET M-file for lyapunov_set.fig
%      LYAPUNOV_SET, by itself, creates a new LYAPUNOV_SET or raises the existing
%      singleton*.
%
%      H = LYAPUNOV_SET returns the handle to a new LYAPUNOV_SET or the handle to
%      the existing singleton*.
%
%      LYAPUNOV_SET('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LYAPUNOV_SET.M with the given input arguments.
%
%      LYAPUNOV_SET('Property','Value',...) creates a new LYAPUNOV_SET or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before lyapunov_set_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to lyapunov_set_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help lyapunov_set

% Last Modified by GUIDE v2.5 13-May-2004 13:29:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @lyapunov_set_OpeningFcn, ...
                   'gui_OutputFcn',  @lyapunov_set_OutputFcn, ...
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

% --- Executes just before lyapunov_set is made visible.
function lyapunov_set_OpeningFcn(hObject, eventdata, handles, varargin)
global DS;
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to lyapunov_set (see VARARGIN)

% Choose default command line output for lyapunov_set
handles.output = hObject;

set(gcf,'WindowStyle','modal');
str = int2str(DS(1).n_lyapunov);
set(handles.edit1,'String',str);
str = num2str(DS(1).step_lyapunov);
set(handles.edit2,'String',str);
str = num2str(DS(1).outstep_lyapunov);
set(handles.edit3,'String',str);


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes lyapunov_set wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = lyapunov_set_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
global DS;
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% OK
neq = length(DS(1).vars);
nlyap = round(str2num(get(handles.edit1,'String')));
steplyap = str2double(get(handles.edit2,'String'));
outstep = str2double(get(handles.edit3,'String'));

close_OK = 1;

% Error checking
if (nlyap<0) | (nlyap>neq)
    close_OK = 0;
    errordlg('Number of exponents is incorrect!','Error number!');
end;

if (steplyap<eps)
    close_OK = 0;
    errordlg('Step value for averaging is incorrect!','Error step!');
end;

if (outstep<steplyap)
    close_OK = 0;
    errordlg('Output step is incorrect!','Error step!');
end;

if close_OK==1
    DS(1).n_lyapunov = nlyap;
    DS(1).step_lyapunov = steplyap;
    DS(1).outstep_lyapunov = outstep;
    delete(gcf);
    update_ds;
end;

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
global DS;
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%  CANSEL
DS(1).n_lyapunov = 0;
DS(1).step_lyapunov = 0.5;
DS(1).outstep_lyapunov = 10;

delete(gcf);

update_ds;


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


