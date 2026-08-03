function Save_point;
% Save initial point to file

global DS;
global matdspath;

cd(matdspath.systems);

[newfile,newpath] = uiputfile([DS(1).name '.pnt'],'Save point to file:');
if newfile~=0
   if isempty(strfind(newfile,'.pnt'))
      namefile=[newpath newfile '.pnt'];
   else 
      namefile=[newpath newfile];
   end;

% Output structure
   Pnt.name = DS(1).name;
   Pnt.coords = DS(1).Xinit;
   Pnt.time_start=DS(1).time_start;

% Write structure to file
  
   save(namefile,'Pnt');

end;

cd(matdspath.main);