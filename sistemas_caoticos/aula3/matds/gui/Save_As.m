% ------------------------------------------------------------
% Callback for Open menu - displays an open dialog
% ------------------------------------------------------------
function varargout = Save_As(h, eventdata, handles, varargin)
% Use UIGETFILE to allow for the selection of a dynamical system.
global matdspath;
global DS;


cd(matdspath.systems);
[filename, pathname] = uiputfile(...
	{'*.mds', 'MATDS-Files (*.mds)'}, ...
	'Select dynamical system');
% If "Cancel" is selected then return
if ~isequal([filename,pathname],[0,0])
% Otherwise construct the fullfilename and Check and write the file.
	File = fullfile(pathname,filename);
        uu=findstr(File,'.mds');
        if isempty(uu)==0
           File=File(1:(uu( length(uu) )-1) );
        end;
% if the MAT-file is not valid, do not save the name
        errcode = 0;
        tempi=exist(File);
        if (tempi>2) & (tempi<7)
           button = questdlg(['Warning! File ' File ' exist!'],...
               'Replace it?','Yes','No','No');
           if strcmp(button,'No')
              errcode = 1;
           end;
        end;

        if errcode == 0
           Check_And_Write(File);
        end;

end
cd(matdspath.main);


