
function varargout=mExit_Callback(h,eventdata,handles,varargin)
% --------------------------------------------------------------------
% End of MATDS-work, closing all windows and exit 
%

global session_time;
global session_windows;
global driver_window;
global DS;
global DSa;
global matdspath;
global nbrwin;
global TRJ_bufer Time_bufer bufer_i;


  Check_And_Write([matdspath.temp filesep 'temp']);  
  close_win;

  delete(DS(1).windows(1));

  t=clock;
  fprintf('\n \n Session time: %10.3f sec. \n',etime(t,session_time));

  clear global DS;
  clear global session_windows;
  clear global DSa;
  clear global driver_window;
  clear global nbrwin;
  clear global TRJ_bufer Time_bufer bufer_i;


return


% --------------------------------------------------------------------

