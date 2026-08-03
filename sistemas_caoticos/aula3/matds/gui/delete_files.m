function delete_files;
% Use UIGETFILE to allow for the selection of a dynamical system.
global matdspath;

cd(matdspath.systems);
[filename, pathname] = uigetfile( ...
	{'*.mds', 'MATDS-Files (*.mds)'; ...
		}, ...
	'Select dynamical system for deleting');
% If "Cancel" is selected then return
if ~isequal([filename,pathname],[0,0])
% Otherwise construct the fullfilename and Check and load the file.
	File = fullfile(pathname,filename);
        uu=findstr(File,'.mds');
        if isempty(uu)==0
           File=File(1:(uu( length(uu) )-1) );
        end;
	Check_And_Delete(File);
end;
cd(matdspath.main);


