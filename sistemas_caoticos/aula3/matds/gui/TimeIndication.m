function TimeIndication
global DS;
% Check and define current output regime for time

   if strcmp(get(DS(1).mainwin.mTimeIndication,'Checked'),'off')==1
      DS(1).time_indication = 1;
      set(DS(1).mainwin.mTimeIndication,'Checked','on');
   else
      DS(1).time_indication = 0;
      set(DS(1).mainwin.mTimeIndication,'Checked','off');
   end;
