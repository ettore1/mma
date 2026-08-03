function update_opt_last;
global DS;
% Check and define current trajectory regime

   if strcmp(get(DS(1).mainwin.mLast_point,'Checked'),'off')==1
      DS(1).currenttrajectory = 1;
      set(DS(1).mainwin.mLast_point,'Checked','on');
   else
      DS(1).currenttrajectory = 0;
      set(DS(1).mainwin.mLast_point,'Checked','off');
   end;



