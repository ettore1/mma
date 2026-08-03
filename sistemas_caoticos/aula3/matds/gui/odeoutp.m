function status = odeoutp(time,Xsol,flag,varargin)
global DS;
global TRJ_bufer Time_bufer bufer_i;
global calculation_progress first_call;
global driver_window;
global P;

%t
%y
status = 0;
neq=length(DS(1).vars);


switch flag
  case 'init'                          % odeplot(tspan,y0,'init')
     
      bufer_i = 1;  
      Time_bufer(bufer_i) = time(1);
      TRJ_bufer(bufer_i,1:neq)=Xsol(1:neq,1)';
      if DS(1).poincare_do>1
          X = Xsol(1:neq,1)';
          t = time(1);
          DS(1).poincare_cur=eval(DS(1).poincare_eq);
      end
     
     % New trajectrories
     if first_call==1
         s = size(DS(1).windows,2);
         for i=2:s
             new_trajectories(DS(1).windows(i)); end; 
     end
     
  case 'done'                           % odeplot([],[],'done')
      status = 1;

  case ''                           % odeplot([],[],'done') 
      if calculation_progress==99
          status = 1;
      else 
          status = 0;
      end;
      if calculation_progress==2
          waitfor(driver_window,'UserData',[0]);  
          %        calculation_progress=1;
      end; 
      X = Xsol(1:neq,1)';
      t = time(1);

% Update time in main window
      if DS(1).time_indication==1
          strng = num2str(t);
          set(DS(1).mainwin.mStatus_text,'String',strng);
      end

% Periodicity checking
      valperiodic=zeros(neq,1);
      for i=1:neq
          if DS(1).periodic{i}~=0
              if X(1,i)>DS(1).periodic_value(i)
                  k=round( X(1,i)/DS(1).periodic_value(i)+0.5 );
                  X(1,i)=X(1,i)-DS(1).periodic_value(i)*k;
                  valperiodic(i,1)=1;
                  status = 1;
              end;                  
              if X(1,i)<0
                  k=round( abs(X(1,i))/DS(1).periodic_value(i)+0.5 );            
                  X(1,i)=X(1,i)+DS(1).periodic_value(i)*k;
                  valperiodic(i,1)=1;
                  status = 1;
              end;                  
          end;
      end;
      Xsol(1:neq,1) = X';

      % Trajectory bufer updating
      bufer_i = bufer_i+1;  
      Time_bufer(bufer_i) = time(1);
      TRJ_bufer(bufer_i,1:neq)=X(1:neq);
      % Changing of initial point
      if DS(1).currenttrajectory == 1
          DS(1).Xinit = X(1:neq);
          DS(1).time_start = t;
      end;

      if max(valperiodic)==1
          if DS(1).poincare_do>1
              DS(1).poincare_cur=eval(DS(1).poincare_eq);
          end
          % Chek output
          nwind = size(DS.windows);
          nwind = nwind(2)-1;
          for i=1:nwind 
              ff = get(DS(1).windows(i+1),'UserData');
              yes_output = 0;
              for ik=1:neq
                  if valperiodic(ik,1)==1
                      checkstring = ['X(' int2str(ik) ')'];
                      if isempty(strfind( ff.Xvalue,checkstring ))==0
                          yes_output = 1;
                      end;
                      if isempty(strfind( ff.Yvalue,checkstring ))==0
                          yes_output = 1;
                      end;
                      if ff.type==2
                          if isempty(strfind( ff.Zvalue,checkstring ))==0
                              yes_output = 1;
                          end;
                      end;
                  end;
              end;
              if yes_output==1
                 new_trajectories(DS(1).windows(i+1));
              end           
          end 
      end

      
      % Output to text windows
      if DS(1).trj_text_out == 1
          fprintf('\n t=%9.4f Y: ',t);
          for i=1:neq
              fprintf(' %10.5f',X(i) );
          end;
      end;
      
      % Output to graphic windows
      nwind = size(DS.windows);
      nwind = nwind(2)-1;
      for i=1:nwind
          ff = get(DS(1).windows(i+1),'UserData');
          
              if ff.type==1                               % 2D plot
                  ux=get(ff.traj,'XData');
                  uy=get(ff.traj,'YData');
                  
                  s1 = eval(ff.Xvalue);
                  s2 = eval(ff.Yvalue);
                  if ff.trj_out==1
                      set(ff.traj,'XData',[ux s1],'YData',[uy s2]);
                  end;
                  drawnow; 
              elseif ff.type==2                           % 3D plot
                  ux=get(ff.traj,'XData');
                  uy=get(ff.traj,'YData');
                  uz=get(ff.traj,'ZData');
                  s1 = eval(ff.Xvalue);
                  s2 = eval(ff.Yvalue);
                  s3 = eval(ff.Zvalue);
                  if ff.trj_out==1
                      set(ff.traj,'XData',[ux s1],'YData',[uy s2],'ZData',[uz s3]);
                  end;
                  drawnow; 
                  
              end;
          end;
      
      % Poincare map analysis
      if (DS(1).poincare_do>0) & (bufer_i>3)
          XK=TRJ_bufer(bufer_i-1,1:neq);
          TK=Time_bufer(bufer_i-1);
          switch DS(1).poincare_do
%  Poincare map by time              
              case 1
                  XK=TRJ_bufer(bufer_i-1,1:neq);
                  TK=Time_bufer(bufer_i-1);
                  TK1 = DS(1).poincare_cur;
                  if (time>DS(1).poincare_cur) & (abs(TK-TK1)>eps)
                      rr=Time_bufer(bufer_i)-Time_bufer(bufer_i-1);
                      Poinc_options = odeset('RelTol',DS(1).rel_error,'AbsTol',DS(1).abs_error,'MaxStep',DS(1).max_step,...
                          'Refine',2,'InitialStep',rr);
                      [TT,XT]=integrator(DS(1).method_int,@oderhs,[TK TK1],XK,Poinc_options,P);
                      kXT = size(XT);
                      t = TT(kXT(1));
                      X = XT(kXT(1),1:neq);
                      DS(1).poincare_cur = DS(1).poincare_cur + eval(DS(1).poincare_eq); 
                      DS(1).poincare_nmbr = DS(1).poincare_nmbr + 1;
                      nwind = size(DS.windows); 
                      nwind = nwind(2)-1; 
                      for i=1:nwind 
                          ff = get(DS(1).windows(i+1),'UserData');
                          if ff.poinc_out==1
                              %                    figure(DS(1).windows(i+1)); 
                              if ff.type == 1                         
                                  Xp = eval(ff.Xvalue); 
                                  Yp = eval(ff.Yvalue);
                                  if DS(1).poincare_nmbr==1 
                                      set(ff.poinc_trj,'Xdata',Xp,'Ydata',Yp);
                                  else 
                                      ux=get(ff.poinc_trj,'XData');
                                      uy=get(ff.poinc_trj,'YData');
                                      set(ff.poinc_trj,'Xdata',[ux Xp],'Ydata',[uy Yp]);
                                  end 
                                  drawnow; 
                              else
                                  Xp = eval(ff.Xvalue); 
                                  Yp = eval(ff.Yvalue);
                                  Zp = eval(ff.Zvalue);
                                  if DS(1).poincare_nmbr==1 
                                      set(ff.poinc_trj,'Xdata',Xp,'Ydata',Yp,'Zdata',Zp);
                                  else 
                                      ux=get(ff.poinc_trj,'XData');
                                      uy=get(ff.poinc_trj,'YData');
                                      uz=get(ff.poinc_trj,'ZData');
                                      set(ff.poinc_trj,'Xdata',[ux Xp],'Ydata',[uy Yp],'Zdata',[uz Zp]);
                                  end 
                              end
                          end
                      end
                  end
              case 2
% Poincare map by secant to both direction                  
                  X = Xsol(1:neq,1)';
                  t = time(1);
                  rr = eval(DS(1).poincare_eq);
                  rr1=rr;
                  XK=X; TK=t;
                  XL=TRJ_bufer(bufer_i-1,1:neq);
                  TL=Time_bufer(bufer_i-1);
                  if (rr*DS(1).poincare_cur)<0
                      k = 0;
                      while (abs(rr)>DS(1).rel_error) & (k<=10)
                          k = k+1;
                          X = oderhs(TK,XK,P);
                          t = TK;
                          df_plane=eval([DS(1).poincare_eq '+' DS(1).poincare_map{2}]);
                          TK1 = TK - rr/df_plane; 
                          rr = TK1 - TL;
                          Poinc_options = odeset('RelTol',DS(1).rel_error,'AbsTol',DS(1).abs_error,'MaxStep',DS(1).max_step,...
                              'Refine',2,'InitialStep',rr);                          
                          [TT,XT]=integrator(DS(1).method_int,@oderhs,[TL TK1],XL,Poinc_options,P);
                          kXT = size(XT);
                          t = TT(kXT(1));
                          X = XT(kXT(1),1:neq);
                          rr = eval(DS(1).poincare_eq);
                          XK = X;
                          TK = t;
                          if (rr*DS(1).poincare_cur)>0
                              XL = X;
                              TL = t;
                          end
                      end;
% Output if all is OK                      
                      if k<10 
                          DS(1).poincare_cur = rr1; 
                          DS(1).poincare_nmbr = DS(1).poincare_nmbr + 1;
                          nwind = size(DS.windows); 
                          nwind = nwind(2)-1; 
                          for i=1:nwind 
                              ff = get(DS(1).windows(i+1),'UserData');
                              if ff.poinc_out==1
                                  if ff.type == 1                         
                                      Xp = eval(ff.Xvalue); 
                                      Yp = eval(ff.Yvalue);
                                      if DS(1).poincare_nmbr==1 
                                          set(ff.poinc_trj,'Xdata',Xp,'Ydata',Yp);
                                      else 
                                          ux=get(ff.poinc_trj,'XData');
                                          uy=get(ff.poinc_trj,'YData');
                                          set(ff.poinc_trj,'Xdata',[ux Xp],'Ydata',[uy Yp]);
                                      end 
                                      drawnow; 
                                  else
                                      Xp = eval(ff.Xvalue); 
                                      Yp = eval(ff.Yvalue);
                                      Zp = eval(ff.Zvalue);
                                      if DS(1).poincare_nmbr==1 
                                          set(ff.poinc_trj,'Xdata',Xp,'Ydata',Yp,'Zdata',Zp);
                                      else 
                                          ux=get(ff.poinc_trj,'XData');
                                          uy=get(ff.poinc_trj,'YData');
                                          uz=get(ff.poinc_trj,'ZData');
                                          set(ff.poinc_trj,'Xdata',[ux Xp],'Ydata',[uy Yp],'Zdata',[uz Zp]);
                                      end 
                                  end
                              end
                          end
                      end;
                  end
              case 3
% Poincare map by secant to positive direction                  
                  X = Xsol(1:neq,1)';
                  t = time(1);
                  rr = eval(DS(1).poincare_eq);
                  rr1=rr;
                  XK=X; TK=t;
                  XL=TRJ_bufer(bufer_i-1,1:neq);
                  TL=Time_bufer(bufer_i-1);
                  if ( (rr*DS(1).poincare_cur)<0 ) & (rr>0)
                      k = 0;
                      while (abs(rr)>DS(1).rel_error) & (k<=10)
                          k = k+1;
                          X = oderhs(TK,XK,P);
                          t = TK;
                          df_plane=eval([DS(1).poincare_eq '+' DS(1).poincare_map{2}]);
                          TK1 = TK - rr/df_plane; 
                          rr = TK1 - TL;
                          Poinc_options = odeset('RelTol',DS(1).rel_error,'AbsTol',DS(1).abs_error,'MaxStep',DS(1).max_step,...
                              'Refine',2,'InitialStep',rr);                          
                          [TT,XT]=integrator(DS(1).method_int,@oderhs,[TL TK1],XL,Poinc_options,P);
                          kXT = size(XT);
                          t = TT(kXT(1));
                          X = XT(kXT(1),1:neq);
                          rr = eval(DS(1).poincare_eq);
                          XK = X;
                          TK = t;
                          if (rr*DS(1).poincare_cur)>0
                              XL = X;
                              TL = t;
                          end
                      end;
% Output if all is OK                      
                      if k<10 
                          DS(1).poincare_cur = rr1; 
                          DS(1).poincare_nmbr = DS(1).poincare_nmbr + 1;
                          nwind = size(DS.windows); 
                          nwind = nwind(2)-1; 
                          for i=1:nwind 
                              ff = get(DS(1).windows(i+1),'UserData');
                              if ff.poinc_out==1
                                  if ff.type == 1                         
                                      Xp = eval(ff.Xvalue); 
                                      Yp = eval(ff.Yvalue);
                                      if DS(1).poincare_nmbr==1 
                                          set(ff.poinc_trj,'Xdata',Xp,'Ydata',Yp);
                                      else 
                                          ux=get(ff.poinc_trj,'XData');
                                          uy=get(ff.poinc_trj,'YData');
                                          set(ff.poinc_trj,'Xdata',[ux Xp],'Ydata',[uy Yp]);
                                      end 
                                      drawnow; 
                                  else
                                      Xp = eval(ff.Xvalue); 
                                      Yp = eval(ff.Yvalue);
                                      Zp = eval(ff.Zvalue);
                                      if DS(1).poincare_nmbr==1 
                                          set(ff.poinc_trj,'Xdata',Xp,'Ydata',Yp,'Zdata',Zp);
                                      else 
                                          ux=get(ff.poinc_trj,'XData');
                                          uy=get(ff.poinc_trj,'YData');
                                          uz=get(ff.poinc_trj,'ZData');
                                          set(ff.poinc_trj,'Xdata',[ux Xp],'Ydata',[uy Yp],'Zdata',[uz Zp]);
                                      end 
                                  end
                              end
                          end
                      end;
                  end
              case 4
% Poincare map by secant to negative direction                  
                  X = Xsol(1:neq,1)';
                  t = time(1);
                  rr = eval(DS(1).poincare_eq);
                  rr1=rr;
                  XK=X; TK=t;
                  XL=TRJ_bufer(bufer_i-1,1:neq);
                  TL=Time_bufer(bufer_i-1);
                  if ( (rr*DS(1).poincare_cur)<0 ) & ( rr<0 )
                      k = 0;
                      while (abs(rr)>DS(1).rel_error) & (k<=10)
                          k = k+1;
                          X = oderhs(TK,XK,P);
                          t = TK;
                          df_plane=eval([DS(1).poincare_eq '+' DS(1).poincare_map{2}]);
                          TK1 = TK - rr/df_plane; 
                          rr = TK1 - TL;
                          Poinc_options = odeset('RelTol',DS(1).rel_error,'AbsTol',DS(1).abs_error,'MaxStep',DS(1).max_step,...
                              'Refine',2,'InitialStep',rr);                          
                          [TT,XT]=integrator(DS(1).method_int,@oderhs,[TL TK1],XL,Poinc_options,P);
                          kXT = size(XT);
                          t = TT(kXT(1));
                          X = XT(kXT(1),1:neq);
                          rr = eval(DS(1).poincare_eq);
                          XK = X;
                          TK = t;
                          if (rr*DS(1).poincare_cur)>0
                              XL = X;
                              TL = t;
                          end
                      end;
% Output if all is OK                      
                      if k<10 
                          DS(1).poincare_cur = rr1; 
                          DS(1).poincare_nmbr = DS(1).poincare_nmbr + 1;
                          nwind = size(DS.windows); 
                          nwind = nwind(2)-1; 
                          for i=1:nwind 
                              ff = get(DS(1).windows(i+1),'UserData');
                              if ff.poinc_out==1
                                  if ff.type == 1                         
                                      Xp = eval(ff.Xvalue); 
                                      Yp = eval(ff.Yvalue);
                                      if DS(1).poincare_nmbr==1 
                                          set(ff.poinc_trj,'Xdata',Xp,'Ydata',Yp);
                                      else 
                                          ux=get(ff.poinc_trj,'XData');
                                          uy=get(ff.poinc_trj,'YData');
                                          set(ff.poinc_trj,'Xdata',[ux Xp],'Ydata',[uy Yp]);
                                      end 
                                      drawnow; 
                                  else
                                      Xp = eval(ff.Xvalue); 
                                      Yp = eval(ff.Yvalue);
                                      Zp = eval(ff.Zvalue);
                                      if DS(1).poincare_nmbr==1 
                                          set(ff.poinc_trj,'Xdata',Xp,'Ydata',Yp,'Zdata',Zp);
                                      else 
                                          ux=get(ff.poinc_trj,'XData');
                                          uy=get(ff.poinc_trj,'YData');
                                          uz=get(ff.poinc_trj,'ZData');
                                          set(ff.poinc_trj,'Xdata',[ux Xp],'Ydata',[uy Yp],'Zdata',[uz Zp]);
                                      end 
                                  end
                              end
                          end
                      end;
                  end
          end
      end
      
      X = Xsol(1:neq,1)';
      t = time(1);
      if DS(1).poincare_do>1
          DS(1).poincare_cur=eval(DS(1).poincare_eq);
      end

end;