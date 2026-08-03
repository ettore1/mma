% ------------------------------------------------------------
% Callback for Open menu - displays an open dialog
% ------------------------------------------------------------
function varargout = mOpen_Callback(h, eventdata, handles, varargin)
% Use UIGETFILE to allow for the selection of a dynamical system.
cd 'Systems';
[filename, pathname] = uigetfile( ...
	{'*.mat', 'All MAT-Files (*.mat)'; ...
		'*.*','All Files (*.*)'}, ...
	'Select dynamical system');
% If "Cancel" is selected then return
if ~isequal([filename,pathname],[0,0])
% Otherwise construct the fullfilename and Check and load the file.
	File = fullfile(pathname,filename);
	% if the MAT-file is not valid, do not save the name
	if Check_And_Load(File,handles)
		handles.LastFIle = File;
		guidata(h,handles)
	end
end
cd '..'


