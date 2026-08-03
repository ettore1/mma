%------------------------------------------------------------
%        Check and load systems file
%------------------------------------------------------------

function pass = Check_And_Load(namefiles)
global DS;
global nbrwin;
global matdspath;
global P;


pass = 0;

DSa=DS;

close_win;

namefs=lower(namefiles);
if isempty(namefiles)
   namefs = lower(DS(1).currfile);
end;

ns=length(namefs);
npos=findstr(namefs,filesep);
curpath = pwd;
shortname=namefs( (npos(length(npos))+1) : ns);
namepath=namefs( 1 : ( npos(length(npos))-1 ) );
cd(namepath);

% Load DS-structure

TMP.windows=[];

if exist([shortname '.mds'])==2
   load([shortname '.mds'],'-mat')
else 
   pass=-1;
   msgbox('Last session files not found! Lorenz system will be defined.','Information','none');
   TMP.windows(1)=DSa(1).windows(1);
end;


if pass==0
   TMP.windows(1)=DSa(1).windows(1);
   nbrwin1=1;
   nbrwin = length(DS(1).windows) - 1;
   k = 1;
   for i=1:nbrwin
     stemp = int2str(i);
     if i<9 stemp=['0' stemp]; end;
     namef=strcat(shortname,['.w' stemp]);
     if exist(namef)==2
         TMP.windows(k+1)=hgload(namef);
         if ishandle(TMP.windows(k+1))
            tmp=get(TMP.windows(k+1),'UserData');
            if tmp.type==1
               set( TMP.windows(k+1),'Name',strcat('Plot 2-D || ',int2str(k) ) );
            end;
            if tmp.type==2
               set( TMP.windows(k+1),'Name',strcat('Plot 3-D || ',int2str(k) ) );
            end;
            tmp.number = k;
            set(TMP.windows(k+1),'UserData',tmp);
            k = k + 1;
         end;
     else
        pass = 2;
     end;
   end;
end;

if pass==1
   errordlg('Error MATDS-file!','Error loading!');
   DS=[];
   DS=DSa;
else 
   if pass==2
      errordlg('Error plot-file!','Error loading!');
   end;
   DS(1).windows=[];
   DS(1).windows=TMP.windows;
   DS(1).mainwin = DSa(1).mainwin;
   DS(1).currfile = [pwd filesep shortname];
   system_gen;

   fprintf('\n ======================================================\n');
   fprintf('\n Investigation of %s system started...',DS(1).currfile);
 
   neq = length(DS(1).vars);

% Checking fields of DS structure
   if isfield(DS(1),'currenttrajectory')==0
      DS(1).currenttrajectory = 0;
   end;
   
   if isfield(DS(1),'time_indication')==0
      DS(1).time_indication = 0;
   end;

   if isfield(DS(1),'trj_text_out')==0
      DS(1).trj_text_out = 0;
   end;


   if isfield(DS(1),'periodic_value')==0
      for i=1:neq 
          DS(1).periodic_value(i) = 0;
      end;
   end;

 if isfield(DS(1),'poincare_map')==0
% Define equation of poincare section {1} - lhs depending on variables {2}
% rhs const. In symbolic format.
     DS(1).poincare_map = [];
% Switch variable for poincare map calculation:   0 - no section; 1 - section on time; 
%                               2 - section by plane in both direction
%                               3 - section by plane in positive direction
%                               4 - section by plane in negative direction                          
     DS(1).poincare_do = 0;
% Define equation of poincare section for evaluation (in internal format)
     DS(1).poincare_eq = [];
% Current sign of section value
     DS(1).poincare_cur = 0;
     DS(1).poincare_nmbr = 0;
 else
     if isfield(DS(1),'poincare_do')~=0
     if DS(1).poincare_do == 1
         DS(1).poincare_cur = DS(1).time_start;
     end
     end
 end;
 
 if isfield(DS(1),'n_lyapunov')==0
     DS(1).n_lyapunov = 0;
     DS(1).step_lyapunov = 0.5;
     DS(1).outstep_lyapunov = 10;
 end


% Update values of parameters
    
   P=[];
   P=DS(1).Val_param;


   update_ds;
end;
cd(curpath);
