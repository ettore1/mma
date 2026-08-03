function field3draw;
% Construction of vector field in 3D window
global win_to_draw;
global DS;

win_to_draw = gcf;

ss = get(win_to_draw,'UserData');
win_to_draw = DS(1).windows(ss.number+1);


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

% Check
  if nbrvar>0
     field3d;
  else
     msgbox('One or more coordinates on window are not DS-variable!',...
            'Sorry, vector field construction is impossible!','warn');
  end;