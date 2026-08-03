% --------------------------------------------------------------------
% Close all active windows
%
 
function close_win;
global session_time;
global session_windows;
global driver_window;
global DS;
global DSa;

  ss = size(DS(1).windows);
  s=ss(1,2);
  for i=2:s
    if ishandle(DS(1).windows(i))==1
     delete(DS(1).windows(i));
    end;
  end;
  tmpw = DS(1).windows(1);
  DS(1).windows = [];
  DS(1).windows(1) = tmpw;


  if ~isempty(session_windows.sysdef)
     if ishandle(session_windows.sysdef.figure1)
        delete(session_windows.sysdef.figure1);
        session_windows.sysdef = [];
     end;         
  end;

  if ~isempty(session_windows.editsys)
     if ishandle(session_windows.editsys.figure_edit)
        delete(session_windows.editsys.figure_edit);
        session_windows.editsys = [];
     end;         
  end;

  if ~isempty(driver_window)
     if ishandle(driver_window)
        delete(driver_window);
        driver_window = [];
     end;         
  end;

  if length(session_windows.vars)~=0
     delete(session_windows.vars);
     session_windows.vars = [];
  end;

  if length(session_windows.params)~=0
     delete(session_windows.params);
     session_windows.params = [];
  end;

  if length(session_windows.intdata)~=0
     delete(session_windows.intdata);
     session_windows.intdata = [];
  end;

% --------------------------------------------------------------------

