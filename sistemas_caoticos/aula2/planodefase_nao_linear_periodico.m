
[t,y]=ode45(@system_nao_linear_periodico,[0:0.1:2500],[1 0 0]);
   h1=t;
   h2=y(:,1); %deslocamento da ponta da viga
   h3=y(:,2); %velocidade da ponta da viga
   h4=y(:,3); %Tens�o El�trica Captada

      figure() %Deslocamento da Ponta da Viga
      plot(h1,h2,'k');
      set(gca,'fontsize',24);
      xlabel('Tempo [amostra]','fontsize',20);
      ylabel('Deslocamento da Ponta da Viga [taxa]','fontsize',20);

      figure() %Velocidade da Ponta da Viga
      plot(h1,h3,'k');
      set(gca,'fontsize',24);
      xlabel('Tempo [amostra]','fontsize',20);
      ylabel('Velocidade da Ponta da Viga [taxa]','fontsize',20);

      figure() %Tens�o El�trica Captada
      plot(h1,h4,'k');
      set(gca,'fontsize',24);
      xlabel('Tempo [amostra]','fontsize',20);
      ylabel('Tens�o El�trica Captada [taxa]','fontsize',20);

      figure() %3D retrato fase da Energia Cin�tica
      plot3(h1,h2,h3,'k');
      grid on;
      set(gca,'fontsize',24);
      xlabel('Tempo [amostra]','fontsize',18);
      ylabel('Deslocamento da Ponta da Viga [taxa]','fontsize',18); 
      zlabel('Velocidade da Ponta da Viga [taxa]','fontsize',18);

      figure() %Retrato de Fase da Energia Cin�tica
      plot(h2(20000:25000,:),h3(20000:25000,:),'k');
      set(gca,'fontsize',24);
      xlabel('Deslocamento da Ponta da Viga [taxa]','fontsize',18); 
      ylabel('Velocidade da Ponta da Viga [taxa]','fontsize',18); 
      

%C�lculo da Pot�ncia
%P= (Vrms)^2/R
Pot_nao_linear_periodico=((rms(h4))^2)/0.1
      
      
      % % EM INGL�S
% 
%       figure() %Deslocamento
%       plot(h1,h2,'k');
%       set(gca,'fontsize',24);
%       xlabel('Time [sample]','fontsize',24);
%       ylabel('Diplacement [rate]','fontsize',24);
% 
%       figure() %Velocity
%       plot(h1,h3,'k');
%       set(gca,'fontsize',24);
%       xlabel('Time [sample]','fontsize',24);
%       ylabel('Velocity [rate]','fontsize',24);
% 
%       figure() %Voltage
%       plot(h1,h4,'k');
%       set(gca,'fontsize',24);
%       xlabel('Time [sample]','fontsize',24);
%       ylabel('Voltage [rate]','fontsize',24);
% 
%       figure() %3D retrato fase
%       plot3(h1,h2,h3,'k');
%       grid on;
%       set(gca,'fontsize',24);
%       xlabel('Time [sample]','fontsize',18);
%       ylabel('Diplacement [rate]','fontsize',18); 
%       zlabel('Velocity [rate]','fontsize',18);
% 
%       figure() %Retrato de Fase
%       plot(h2(20000:25000,:),h3(20000:25000,:),'k');
%       set(gca,'fontsize',24);
%       xlabel('Diplacement [rate]','fontsize',24); 
%       ylabel('Velocity [rate]','fontsize',24); 