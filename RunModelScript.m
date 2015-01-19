%% define ode options :
tfinal  = 1e2;                              % final time

%% configure integrator (check 'doc ode15s' for more info)
options = odeset('NonNegative',[1:4]);      % ensures variables stay positive 
                                            % (this is not always necessary 
                                            % but can be helpful, but make sure 
                                            % your system is actually a positive system!)

options = odeset(options, 'RelTol', 1e-3,...
                          'AbsTol', 1e-6);  % accuracy of integrator 
                                            % (here set to default values)

%% set parameters

k = struct();


k.s         = 1e4; %nutrient concentration
k.dm       = 0.1;%mRNA degradation rate
k.ns       = 0.5;
k.nr       = 7459;
k.nt       = 300;
k.nm       = 300;
k.nq       = 300;
k.gamma_max = 1260;
k.K_gamma   = 7;
k.vt       = 726;
k.Kt       = 1000;
k.vm        = 5800;
k.Km        = 1000;
k.wr        = 930;
%k.we        = 4.14;
k.wt        = 4.14;
k.wm        = 4.14;
k.wq        = 948.93;
k.theta_r   = 426.87;
k.theta_nr  = 4.38;
k.theta_x   = k.theta_nr;
k.Kq        = 152219;
k.hq        = 4;
k.k_b       = 1;
k.k_u       = 1;
%k.k_cm      = 0.00599;
%k.M         = 1e8;



%% set initial values
a0      = 1;
b0      = 1;
c0      = 0;
d0      = 0;

x0      = [a0, b0, c0, d0]; % definition of the initial vector of variables

%% simulate
[t,result] = ode15s(@(t,result) toymodel_ode(t,result,k),[0,tfinal],x0,options);

%% rename variables
a = result(:,1);    % a = first column of result
b = result(:,2);    % b = second column of result
c = result(:,3);    % ... 
d = result(:,4);

%% plot results
figure(1); clf; 
subplot(4,1,1)
plot(t,a); ylabel('a', 'fontsize', 14);

subplot(4,1,2)
plot(t,b); ylabel('b', 'fontsize', 14);

subplot(4,1,3)
plot(t,c); ylabel('c', 'fontsize', 14);

subplot(4,1,4)
plot(t,d); ylabel('d', 'fontsize', 14); xlabel('time', 'fontsize', 14)
