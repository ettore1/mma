function Load_point;
global DS;
global session_windows;
global matdspath;

neq=length(DS(1).vars);

cd(matdspath.systems);

% Load point from file

[fname,pname] = uigetfile([DS(1).name '.pnt'],'Select the file with DS-point');

namefile = [pname fname];

U=load(namefile,'-mat');

if isfield(U,'Pnt') == 0
   errordlg('It is not point file!','Read error!');
   return;
else
   Pnt = U.Pnt;
end;   

neqpnt = length(Pnt.coords);

was_read = 0;
UsrDat = get(session_windows.vars,'UserData');


if strcmp(Pnt.name,DS(1).name)==1
   if neqpnt==neq
      DS(1).time_start = Pnt.time_start;
      for i=1:neq
          UsrDat.strings{i} = num2str( Pnt.coords(i) );
      end; 
      was_read = 1;
   else
      errordlg('Bad dimentions of point','Read error!');
   end;
else
   button = questdlg('Do you want to read this point?',...
           'Wrong name of system!','Yes','No','No');
   if strcmp(button,'Yes')
      k=min(neq,neqpnt);      
      DS(1).time_start = Pnt.time_start;
      for i=1:k
          UsrDat.strings{i} = num2str( Pnt.coords(i) );
      end; 
      was_read = 1;
   end;
end;

% If information was read update window
 if was_read == 1
    nvars = length(UsrDat.strings);
    for i=1:UsrDat.nbr
        set(UsrDat.edt(i),'String',UsrDat.strings{i+UsrDat.old});
    end;
    set(session_windows.vars,'UserData',UsrDat);
    
  end;

cd(matdspath.main);