function equilibria;
global P;
global DS;

npars = length(DS(1).param);

for i=1:npars
   P(i) = DS(1).Val_param(i);
end;


[u,fval,nit,code]=equil_find(DS(1).time_start,DS(1).Xinit);
neq=length(DS(1).vars);
if code==0

    X = u;
    t = DS(1).time_start;
    Jcb=ode_jacob(t,X,P);
    eigenvals = eig(Jcb);
    rr = max( real(eigenvals) );
    if ( rr>eps )
       colorval = 'r';
    elseif abs(rr)<eps
       colorval = 'm';
    else 
       colorval = 'g';
    end;

    nwind = size(DS.windows);
    nwind = nwind(2)-1;

%  Output to text window
    fprintf('\n             Equilibrium is found!');
    fprintf('\n Coordinates: \n');
    for i=1:neq
        fprintf('   %10.5f',X(i));
    end;
    fprintf('\n');
    eigenvals

%  Output to graphic windows

    for i=1:nwind
     ff = get(DS(1).windows(i+1),'UserData');
     figure(DS(1).windows(i+1));
     if ff.equil_out>0
       if     ff.type==1
            s1 = eval(ff.Xvalue);
            s2 = eval(ff.Yvalue);
            line(s1,s2,'Marker','o','MarkerEdgeColor','k','MarkerFaceColor',colorval);
       elseif ff.type==2
            s1 = eval(ff.Xvalue);
            s2 = eval(ff.Yvalue);
            s3 = eval(ff.Zvalue);
            line(s1,s2,s3,'Marker','o','MarkerEdgeColor','k','MarkerFaceColor',colorval);
       end;
     end;

    end;   
else
  if code==2
     errstring='Number of iterations > nmax';
  else
     errstring='Matrix of algebraic system is degenerate!';
  end;
  errordlg(errstring,'Equilibrium not find!');
end
