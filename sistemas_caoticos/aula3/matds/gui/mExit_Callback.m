% --------------------------------------------------------------------
% End of work and exit 
%

function varargout=mExit_Callback
global session_time;
global DS;
global calculation_progress;

%close_matds;

if calculation_progress~=0
   errordlg('Press STOP in Driver-window!','Calculation is in progress!');
else
   delete(gcf);
end;

%return


% --------------------------------------------------------------------

