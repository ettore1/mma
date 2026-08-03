function res=Delete2D;
global DS;
global nbrwin;
global calculation_progress;

sn = get(gcf,'UserData');
sn = sn.number;

ss = size(DS(1).windows);
s=ss(1,2);

if s==2
   bb=questdlg('Do you want to close? ','This window is a last!!! ','Yes','No','No');
   if isequal(bb,'No')
      return;
   end;
end;

if calculation_progress==1 
   errordlg('Switch to PAUSE or STOP',' Calculation in progress!!!');
   return;
end;


temp=zeros(1,s-1);
temp(1) = DS(1).windows(1);

for i=2:(sn-1)
  tmp = get(DS(1).windows(i),'UserData');
    tmp.number = i;
    set(DS(1).windows(i),'UserData',tmp);
    set( DS(1).windows(i),'Name',strcat('Plot 2-D || ',int2str(i-1) ) );
    temp(i) = DS(1).windows(i);
end;

for i=(sn+1):s
    tmp = get(DS(1).windows(i),'UserData');
    tmp.number = i-1;
    set(DS(1).windows(i),'UserData',tmp);
    set( DS(1).windows(i),'Name',strcat('Plot 2-D || ',int2str(i-2) ) )
    temp(i-1) = DS(1).windows(i);
end;

DS(1).windows = temp;
nbrwin = nbrwin - 1;
delete(gcf);
