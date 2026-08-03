function [T,Y]=integrator(method,rhsfunc,interval,initialval,options,varargin);

if method==1
   [T,Y] = ode113(rhsfunc,interval,initialval,options,varargin{:});
end;

if method==2
   [T,Y] = ode23(rhsfunc,interval,initialval,options,varargin{:});
end;

if method==3
   [T,Y] = ode23(rhsfunc,interval,initialval,options,varargin{:});
end;

if method==4
   [T,Y] = ode23s(rhsfunc,interval,initialval,options,varargin{:});
end;

if method==5
   [T,Y] = ode23t(rhsfunc,interval,initialval,options,varargin{:});
end;

if method==6
   [T,Y] = ode23tb(rhsfunc,interval,initialval,options,varargin{:});
end;

if method==7
   [T,Y] = ode45(rhsfunc,interval,initialval,options,varargin{:});
end;

if method==8
   [T,Y] = ode78(rhsfunc,interval,initialval,options,varargin{:});
end;

if method==9
   [T,Y] = ode87(rhsfunc,interval,initialval,options,varargin{:});
end;