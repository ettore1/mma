function update_ds;
% Updating menu items and information fields
global DS;
global calculation_progress;


nn=size(DS(1).jacobian);
nn=nn(1);
if nn==0
   set(DS(1).mainwin.text11,'String','Numerically');
else
   set(DS(1).mainwin.text11,'String','Symbolically');
end;

set(DS(1).mainwin.mSystem_text,'String',DS(1).name);
   

if calculation_progress==1
   set(DS(1).mainwin.mCompute,'Enable','off');
%   set(DS(1).mainwin.mWindow,'Enable','off');
   set(DS(1).mainwin.mFile,'Enable','off');
   set(DS(1).mainwin.mResearch,'Enable','off');
   set(DS(1).mainwin.mSystem,'Enable','off');
   set(DS(1).mainwin.mIntegrationdata,'Enable','off');
else
   set(DS(1).mainwin.mCompute,'Enable','on');
%   set(DS(1).mainwin.mWindow,'Enable','on');
   set(DS(1).mainwin.mFile,'Enable','on');
   set(DS(1).mainwin.mResearch,'Enable','on');
   set(DS(1).mainwin.mSystem,'Enable','on');
   set(DS(1).mainwin.mIntegrationdata,'Enable','on');
end;

if calculation_progress==2
   set(DS(1).mainwin.mSystem,'Enable','off');
   set(DS(1).mainwin.mIntegrationdata,'Enable','off');
end;

if calculation_progress==1
   set(DS(1).mainwin.mStatus_text,'String',' busy...');
end;
if calculation_progress==0
   set(DS(1).mainwin.mStatus_text,'String',' ready');
end;
if calculation_progress==2
   set(DS(1).mainwin.mStatus_text,'String',' pause');
end;

if DS(1).method_int == 1 
   set(DS(1).mainwin.mMethod_text,'String','ode113' );
end;
if DS(1).method_int == 2 
   set(DS(1).mainwin.mMethod_text,'String','ode15s' );
end;
if DS(1).method_int == 3 
   set(DS(1).mainwin.mMethod_text,'String','ode23' );
end;
if DS(1).method_int == 4 
   set(DS(1).mainwin.mMethod_text,'String','ode23s' );
end;
if DS(1).method_int == 5 
   set(DS(1).mainwin.mMethod_text,'String','ode23t' );
end;
if DS(1).method_int == 6 
   set(DS(1).mainwin.mMethod_text,'String','ode23tb' );
end;
if DS(1).method_int == 7 
   set(DS(1).mainwin.mMethod_text,'String','ode45' );
end;
if DS(1).method_int == 8 
   set(DS(1).mainwin.mMethod_text,'String','ode78' );
end;
if DS(1).method_int == 9 
   set(DS(1).mainwin.mMethod_text,'String','ode87' );
end;

if DS(1).time_indication==1
    set(DS(1).mainwin.mTimeIndication,'Checked','on');
else
    set(DS(1).mainwin.mTimeIndication,'Checked','off');
end;

if DS(1).n_lyapunov>0
    set(DS(1).mainwin.mLyapunov,'Checked','on');
else
    set(DS(1).mainwin.mLyapunov,'Checked','off');
end;


% Task string
stringtask = 'Trajectory';

if ~isempty(DS(1).poincare_map)
    stringtask=[stringtask '+' 'Pnc'];
end;
if DS(1).n_lyapunov>0
    stringtask=[stringtask '+' 'Lyap'];
end;
set(DS(1).mainwin.mTask_text,'String',stringtask );


set(DS(1).mainwin.mError_text,'String',num2str(DS(1).rel_error) );
set(DS(1).mainwin.mMaxstep_text,'String',num2str(DS(1).max_step) );

   tmpstr = [];
   if length(DS(1).currfile)>25
      ss=findstr(DS(1).currfile,filesep);
      j=length(ss);
      k=1;
      while (ss(k)<20) & (k<j)
             k=k+1;
      end;
      tmpstr{1}=[DS(1).currfile(1:(ss(k)-1)) '..'];
      tmpstr{2}=[DS(1).currfile( (ss(k)):length(DS(1).currfile) ) '.*'];
   else
      tmpstr{1}=DS(1).currfile;
   end;      

   set(DS(1).mainwin.mDuration_text,'String',tmpstr);   

%   set(DS(1).mainwin.mEquilibrium,'Enable','off');
   set(DS(1).mainwin.mPeriodicSol,'Enable','off');
   set(DS(1).mainwin.mPoincare,'Enable','on');

%    Poincare map menu parameters
   if isempty(DS(1).poincare_map)
      set(DS(1).mainwin.mPoincare,'Checked','off');
   else
      set(DS(1).mainwin.mPoincare,'Checked','on');    
   end;
      
%   set(DS(1).mainwin.mLyapunov,'Enable','off');
%   set(DS(1).mainwin.mOut_text,'Enable','off');
   set(DS(1).mainwin.mInformation,'Enable','off');
   set(DS(1).mainwin.mMethods,'Enable','off');

% Check Options menu - current trajectory

   if DS(1).currenttrajectory == 1;
      set(DS(1).mainwin.mLast_point,'Checked','on');
   else
      set(DS(1).mainwin.mLast_point,'Checked','off');
   end;

% Ckeck Option menu - regime of text output   
  if DS(1).trj_text_out == 0
     set(DS(1).mainwin.mOut_text,'Checked','off');
  else 
     set(DS(1).mainwin.mOut_text,'Checked','on');
  end;

if isfield(DS(1),'poincare_do')
    if DS(1).poincare_do == 1
        DS(1).poincare_cur = DS(1).time_start; 
    end
end
  


DS(1).mainwin;
