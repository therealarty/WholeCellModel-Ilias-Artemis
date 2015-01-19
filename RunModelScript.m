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

k.a     = 0.01;     % synthesis rate of species a
k.ab    = 0.2;      % rate constant of a reacting with b to form c
k.c     = 0.01;     % rate constant of c reacting back to give a and b
k.cat   = 0.1;      % maximal rate of c converting to d
k.m     = 0.5;      % amount of c (or threshold), at which rate of conversion 
                      % from c to d is half-maximal
k.deg   = 0.02;     % degradation rate constant of d


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
