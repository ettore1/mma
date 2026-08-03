function [Texp,Lexp]=lyapunov(n,tstart,stept,tend,ystart,ioutp);
global DS;
global P;
global calculation_progress first_call;
global driver_window;
global TRJ_bufer Time_bufer bufer_i;

%
%    Lyapunov exponent calcullation for ODE-system.
%
%    The alogrithm employed in this m-file for determining Lyapunov
%    exponents was proposed in
%
%         A. Wolf, J. B. Swift, H. L. Swinney, and J. A. Vastano,
%        "Determining Lyapunov Exponents from a Time Series," Physica D,
%        Vol. 16, pp. 285-317, 1985.
%
%    For integrating ODE system can be used any MATLAB ODE-suite methods. 
% This function is a part of MATDS program - toolbox for dynamical system investigation
%    See:    http://www.math.rsu.ru/mexmat/kvm/matds/
%
%    Input parameters:
%      n - number of equation
%      rhs_ext_fcn - handle of function with right hand side of extended ODE-system.
%              This function must include RHS of ODE-system coupled with 
%              variational equation (n items of linearized systems, see Example).                   
%      fcn_integrator - handle of ODE integrator function, for example: @ode45                  
%      tstart - start values of independent value (time t)
%      stept - step on t-variable for Gram-Schmidt renormalization procedure.
%      tend - finish value of time
%      ystart - start point of trajectory of ODE system.
%      ioutp - step of print to MATLAB main window. ioutp==0 - no print, 
%              if ioutp>0 then each ioutp-th point will be print.
%
%    Output parameters:
%      Texp - time values
%      Lexp - Lyapunov exponents to each time value.
%
%    Users have to write their own ODE functions for their specified
%    systems and use handle of this function as rhs_ext_fcn - parameter.      
%
%    Example. Lorenz system:
%               dx/dt = sigma*(y - x)     = f1
%               dy/dt = r*x - y - x*z = f2
%               dz/dt = x*y - b*z     = f3
%
%    The Jacobian of system: 
%        | -sigma  sigma  0 |
%    J = |   r-z    -1   -x |
%        |    y      x   -b |
%
%    Then, the variational equation has a form:
% 
%    F = J*Y
%    where Y is a square matrix with the same dimension as J.
%    Corresponding m-file:
%        function f=lorenz_ext(t,X)
%         SIGMA = 10; R = 28; BETA = 8/3;
%         x=X(1); y=X(2); z=X(3);
%
%         Y= [X(4), X(7), X(10);
%             X(5), X(8), X(11);
%             X(6), X(9), X(12)];
%         f=zeros(9,1);
%         f(1)=SIGMA*(y-x); f(2)=-x*z+R*x-y; f(3)=x*y-BETA*z;
%
%         Jac=[-SIGMA,SIGMA,0; R-z,-1,-x; y, x,-BETA];
%  
%         f(4:12)=Jac*Y;
%
%    Run Lyapunov exponent calculation:
%     
%    [T,Res]=lyapunov(3,@lorenz_ext,@ode45,0,0.5,200,[0 1 0],10);   
%   
%    See files: lorenz_ext, run_lyap.   
%  
% --------------------------------------------------------------------
% Copyright (C) 2004, Govorukhin V.N.
% This file is intended for use with MATLAB and was produced for MATDS-program
% http://www.math.rsu.ru/mexmat/kvm/matds/
% lyapunov.m is free software. lyapunov.m is distributed in the hope that it 
% will be useful, but WITHOUT ANY WARRANTY. 
%



%
%       n=number of nonlinear odes
%       n2=n*(n+1)=total number of odes
%

options = odeset('RelTol',DS(1).rel_error,'AbsTol',DS(1).abs_error,'MaxStep',DS(1).max_step,...
                 'OutputFcn',@odeoutp,'Refine',0,'InitialStep',0.001);
             

n_exp = DS(1).n_lyapunov;
n1=n; n2=n1*(n_exp+1);
neq=n2;

%  Number of steps

nit = round((tend-tstart)/stept)+1;

% Memory allocation 

y=zeros(n2,1); 
cum=zeros(n2,1); 
y0=y;
gsc=cum; 
znorm=cum;

% Initial values

y(1:n)=ystart(:);

for i=1:n_exp y((n1+1)*i)=1.0; end;

t=tstart;


Fig_Lyap = figure;
set(Fig_Lyap,'Name','Lyapunov exponents','NumberTitle','off');
set(Fig_Lyap,'CloseRequestFcn','');
hold on;
box on;
timeplot = tstart+(tend-tstart)/10;
axis([tstart timeplot -1 1]);
title('Dynamics of Lyapunov exponents');
xlabel('t');
ylabel('Lyapunov exponents');
Fig_Lyap_Axes = findobj(Fig_Lyap,'Type','axes');

for i=1:n_exp
       PlotLyap{i}=plot(tstart,0);        
end;

       uu=findobj(Fig_Lyap,'Type','line'); 
       for i=1:size(uu,1)
           set(uu(i),'EraseMode','none') ;
           set(uu(i),'XData',[],'YData',[]);
           set(uu(i),'Color',[0 0 rand]);
       end

ITERLYAP = 0;

% Main loop
calculation_progress = 1;

while t<tend
    tt = t + stept;
    ITERLYAP = ITERLYAP+1;
    if tt>tend, tt = tend; end;
% Solutuion of extended ODE system 

%  [T,Y] = feval(fcn_integrator,rhs_ext_fcn,[t t+stept],y);     
   while calculation_progress == 1
       [T,Y] = integrator(DS(1).method_int,@ode_lin,[t tt],y,options,P,n,neq,n_exp);
       first_call = 0;
       if calculation_progress == 99, break; end;
       if ( T(size(T,1))<tt ) & (calculation_progress~=0)
         y=Y(size(Y,1),:);
         y(1,1:n)=TRJ_bufer(bufer_i,1:n);
         t = Time_bufer(bufer_i);
         calculation_progress = 1;
       else
         calculation_progress = 0;
       end;
   end;

   if (calculation_progress == 99) 
       break; 
   else
       calculation_progress = 1;
   end;
   
  t=tt;
  y=Y(size(Y,1),:);
  
  first_call = 0;

%
%       construct new orthonormal basis by gram-schmidt
%

  znorm(1)=0.0;
  for j=1:n1 znorm(1)=znorm(1)+y(n1+j)^2; end;

  znorm(1)=sqrt(znorm(1));

  for j=1:n1 y(n1+j)=y(n1+j)/znorm(1); end;

  for j=2:n_exp
      for k=1:(j-1)
          gsc(k)=0.0;
          for l=1:n1 gsc(k)=gsc(k)+y(n1*j+l)*y(n1*k+l); end;
      end;
 
      for k=1:n1
          for l=1:(j-1)
              y(n1*j+k)=y(n1*j+k)-gsc(l)*y(n1*l+k);
          end;
      end;

      znorm(j)=0.0;
      for k=1:n1 znorm(j)=znorm(j)+y(n1*j+k)^2; end;
      znorm(j)=sqrt(znorm(j));

      for k=1:n1 y(n1*j+k)=y(n1*j+k)/znorm(j); end;
  end;

%
%       update running vector magnitudes
%

  for k=1:n_exp cum(k)=cum(k)+log(znorm(k)); end;

%
%       normalize exponent
%

  rescale = 0;
  u1 =1.e10;
  u2 =-1.e10;

  for k=1:n_exp 
      lp(k)=cum(k)/(t-tstart); 

%  Plot 
 
      Xd=get(PlotLyap{k},'Xdata');
      Yd=get(PlotLyap{k},'Ydata');

      if timeplot<t
            u1=min(u1,min(Yd));
            u2=max(u2,max(Yd));
      end;
      Xd=[Xd t]; Yd=[Yd lp(k)];
      set(PlotLyap{k},'Xdata',Xd,'Ydata',Yd);
  end;
  if timeplot<t
     timeplot = timeplot+(tend-tstart)/20;
     figure(Fig_Lyap);
     axis([tstart timeplot u1 u2]); end;

  drawnow;

 

% Output modification

  if ITERLYAP==1
     Lexp=lp;
     Texp=t;
  else
     Lexp=[Lexp; lp];
     Texp=[Texp; t];
  end;

  
  if (mod(ITERLYAP,ioutp)==0)
     for k=1:n_exp
         txtstring{k}=['\lambda_' int2str(k) '=' num2str(lp(k))];
     end
     legend(Fig_Lyap_Axes,txtstring,3);
  end;


end;

   ss=warndlg('Attention! Plot of lyapunov exponents will be closed!','Press OK to continue!');
   uiwait(ss);
   delete(Fig_Lyap); 
   
     fprintf('\n \n Results of Lyapunov exponents calculation: \n t=%6.4f',t);
     for k=1:n_exp fprintf(' L%d=%f; ',k,lp(k)); end;
     fprintf('\n');
   
         if ~isempty(driver_window)
             if ishandle(driver_window)
                 delete(driver_window);
                 driver_window = [];
             end;         
         end;
         
   calculation_progress = 0;

   update_ds;
   